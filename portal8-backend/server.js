const express = require('express');
const Razorpay = require('razorpay');
const cors = require('cors');
const fetch = require('node-fetch');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

<<<<<<< HEAD
// Razorpay setup
=======
>>>>>>> e1f7032 (Update server.js with webhook fix and package updates)
const mode = process.env.RAZORPAY_MODE || 'TEST';
const key_id = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_ID : process.env.RAZORPAY_TEST_KEY_ID;
const key_secret = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_SECRET : process.env.RAZORPAY_TEST_KEY_SECRET;

if (!key_id || !key_secret) {
  console.error("❌ Razorpay keys missing! Check your .env file.");
  process.exit(1);
}

const razorpay = new Razorpay({ key_id, key_secret });

<<<<<<< HEAD
// Country detection from IP
async function getCountryFromIP(ip) {
  try {
    const token = process.env.IPINFO_TOKEN;
    const res = await fetch(`https://ipinfo.io/${ip}/json?token=${token}`);
    const data = await res.json();
    return data.country || 'IN';
  } catch (err) {
    console.error('🌐 IP lookup failed:', err.message);
    return 'IN';
  }
}

// Country detection from GPS
async function getCountryFromLocation(lat, lng) {
  try {
    const key = process.env.OPENCAGE_KEY;
    const res = await fetch(`https://api.opencagedata.com/geocode/v1/json?q=${lat}+${lng}&key=${key}`);
    const data = await res.json();
    const components = data.results?.[0]?.components;
    return components?.country_code?.toUpperCase() || null;
  } catch (err) {
    console.error('📍 GPS lookup failed:', err.message);
    return null;
  }
}


<<<<<<< HEAD
// Debug route
app.get('/test', (req, res) => {
  console.log('✅ /test route hit');
  res.send('✅ Test route is working');
});

// Country detection
app.get('/geo', async (req, res) => {
  console.log('📡 /geo route hit');
  try {
    const { lat, lng } = req.query;
    let country = null;

    if (lat && lng) {
      country = await getCountryFromLocation(lat, lng);
      console.log(`📍 GPS-based country: ${country}`);
    }

    if (!country) {
      const ip = req.headers['x-forwarded-for']?.split(',')[0] || req.connection.remoteAddress || '8.8.8.8';
      country = await getCountryFromIP(ip);
      console.log(`🌍 IP-based country: ${country} from IP: ${ip}`);
    }

    res.json({ country });
  } catch (err) {
    console.error('❌ /geo route failed:', err.message);
    res.status(200).json({ country: 'IN', fallback: true });
  }
});

// Razorpay order creation
app.post('/create-order', async (req, res) => {
  try {
    const { lat, lng, amount, receipt = `receipt_${Date.now()}` } = req.body;
    let country = null;

    if (lat && lng) {
      country = await getCountryFromLocation(lat, lng);
    }

    if (!country) {
      const ip = req.headers['x-forwarded-for']?.split(',')[0] || req.connection.remoteAddress || '8.8.8.8';
      country = await getCountryFromIP(ip);
    }

    const currency = country === 'IN' ? 'INR' : 'USD';

    if (!amount || isNaN(amount)) {
      return res.status(400).json({ error: 'Invalid amount' });
    }

=======
app.post('/create-order', async (req, res) => {
  try {
    const { amount, currency = 'INR', receipt = `receipt_${Date.now()}` } = req.body;
    if (!amount || isNaN(amount)) return res.status(400).json({ error: 'Invalid amount' });

>>>>>>> e1f7032 (Update server.js with webhook fix and package updates)
    const order = await razorpay.orders.create({
      amount: amount * 100,
      currency,
      receipt,
      payment_capture: 1,
    });

<<<<<<< HEAD
    console.log(`✅ Order created: ${order.id} | Currency: ${currency} | Country: ${country}`);
=======
    console.log('✅ Order created:', order.id);
>>>>>>> e1f7032 (Update server.js with webhook fix and package updates)
    res.json(order);
  } catch (error) {
    console.error('❌ Order creation error:', error.message);
    res.status(500).json({ error: error.message });
  }
});

<<<<<<< HEAD
// Correct port binding for Render
=======
>>>>>>> e1f7032 (Update server.js with webhook fix and package updates)
const PORT = process.env.PORT || 3000;
console.log(`🛠️ PORT from environment: ${process.env.PORT}`);
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
