const express = require('express');
const Razorpay = require('razorpay');
const cors = require('cors');
const fetch = require('node-fetch');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

const mode = process.env.RAZORPAY_MODE || 'TEST';
const key_id = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_ID : process.env.RAZORPAY_TEST_KEY_ID;
const key_secret = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_SECRET : process.env.RAZORPAY_TEST_KEY_SECRET;

if (!key_id || !key_secret) {
  console.error("❌ Razorpay keys missing! Check your .env file.");
  process.exit(1);
}

const razorpay = new Razorpay({ key_id, key_secret });

// 🌍 Utility to detect country from IP
async function getCountryFromIP(ip) {
  try {
    const res = await fetch(`https://ipapi.co/${ip}/json`);
    const data = await res.json();
    return data.country || 'IN'; // fallback to IN
  } catch (err) {
    console.error('🌐 IP lookup failed:', err.message);
    return 'IN';
  }
}

// ✅ Health check
app.get('/ping', (req, res) => {
  res.send('✅ Server is alive');
});

// 🌍 Country detection endpoint for Flutter
app.get('/geo', async (req, res) => {
  const ip = req.headers['x-forwarded-for']?.split(',')[0] || req.connection.remoteAddress;
  const country = await getCountryFromIP(ip);
  res.json({ country });
});

// 🧾 Create Razorpay order
app.post('/create-order', async (req, res) => {
  try {
    const ip = req.headers['x-forwarded-for']?.split(',')[0] || req.connection.remoteAddress;
    const country = await getCountryFromIP(ip);
    const currency = country === 'IN' ? 'INR' : 'USD';

    const { amount, receipt = `receipt_${Date.now()}` } = req.body;
    if (!amount || isNaN(amount)) return res.status(400).json({ error: 'Invalid amount' });

    const order = await razorpay.orders.create({
      amount: amount * 100,
      currency,
      receipt,
      payment_capture: 1,
    });

    console.log(`✅ Order created: ${order.id} | Currency: ${currency} | IP: ${ip}`);
    res.json(order);
  } catch (error) {
    console.error('❌ Order creation error:', error.message);
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
