app.get('/', (req, res) => {
  res.send('✅ Root route is working');
});
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

// 🌍 Detect country from IP using ipinfo.io
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

app.get('/test', (req, res) => {
  res.send('✅ Test route is working');
});

// 📍 Detect country from GPS coordinates using OpenCage
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

// ✅ Health check
app.get('/ping', (req, res) => {
  res.send('✅ Server is alive');
});

// ✅ Debug route to confirm server is serving routes
app.get('/test', (req, res) => {
  res.send('✅ Test route is working');
});

// 🌍 Country detection endpoint for Flutter
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

// 🧾 Create Razorpay order
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

    const order = await razorpay.orders.create({
      amount: amount * 100,
      currency,
      receipt,
      payment_capture: 1,
    });

    console.log(`✅ Order created: ${order.id} | Currency: ${currency} | Country: ${country}`);
    res.json(order);
  } catch (error) {
    console.error('❌ Order creation error:', error.message);
    res.status(500).json({ error: error.message });
  }
});

// ✅ Correct port binding for Render (no fallback)
const PORT = process.env.PORT;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log('✅ /geo route registered and ready');
});
