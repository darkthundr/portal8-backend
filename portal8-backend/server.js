const express = require('express');
const Razorpay = require('razorpay');
const cors = require('cors');
const fetch = require('node-fetch');
const admin = require('firebase-admin');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// 🔐 Firebase setup from env
let serviceAccount;
try {
  serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
} catch (err) {
  console.error("❌ Failed to parse FIREBASE_SERVICE_ACCOUNT:", err.message);
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();

// 🧾 Razorpay setup
const mode = process.env.RAZORPAY_MODE || 'TEST';
const key_id = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_ID : process.env.RAZORPAY_TEST_KEY_ID;
const key_secret = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_SECRET : process.env.RAZORPAY_TEST_KEY_SECRET;

if (!key_id || !key_secret) {
  console.error("❌ Razorpay keys missing! Check your .env file.");
  process.exit(1);
}

const razorpay = new Razorpay({ key_id, key_secret });

// 🌍 Country detection from IP
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

// 📍 Country detection from GPS
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

// ✅ Test route
app.get('/test', (req, res) => {
  console.log('✅ /test route hit');
  res.send('✅ Test route is working');
});

// 🌐 Country detection route
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

// 🧾 Razorpay order creation
app.post('/create-order', async (req, res) => {
  try {
    const { amount, currency, receipt, userId, portalId } = req.body;
    console.log(`📦 Incoming order payload:`, req.body);

    if (!amount || isNaN(amount) || amount <= 0) {
      return res.status(400).json({ error: 'Invalid amount' });
    }

    const supportedCurrencies = ['INR', 'USD'];
    const finalCurrency = supportedCurrencies.includes(currency) ? currency : 'INR';

    const order = await razorpay.orders.create({
      amount: amount * 100,
      currency: finalCurrency,
      receipt: receipt || `receipt_${Date.now()}`,
      payment_capture: 1,
      notes: {
        userId,
        portalId,
      },
    });

    console.log(`✅ Order created: ${order.id} | Currency: ${order.currency}`);
    res.json(order);
  } catch (error) {
    console.error('❌ Order creation error:', error.message);
    res.status(500).json({ error: error.message });
  }
});

// 🔓 Razorpay payment verification + Firestore unlock
app.post('/verify-payment', async (req, res) => {
  const { paymentId, userId, portalId } = req.body;

  if (!paymentId || !userId || !portalId) {
    return res.status(400).json({ success: false, error: 'Missing required fields' });
  }

  try {
    const response = await fetch(`https://api.razorpay.com/v1/payments/${paymentId}`, {
      method: 'GET',
      headers: {
        Authorization: 'Basic ' + Buffer.from(`${key_id}:${key_secret}`).toString('base64'),
      },
    });

    const data = await response.json();

    if (data.status === 'captured') {
      console.log(`✅ Payment verified: ${paymentId}`);

      const userRef = db.collection('users').doc(userId);

      try {
        await userRef.set({}, { merge: true });
        await userRef.update({
          unlockedPortals: admin.firestore.FieldValue.arrayUnion(portalId),
          paymentHistory: admin.firestore.FieldValue.arrayUnion({
            paymentId,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            amount: data.amount ? data.amount / 100 : 0,
            currency: data.currency || 'INR',
            type: portalId,
            source: 'client',
          }),
        });

        console.log(`🔓 Portal ${portalId} unlocked and payment logged for user ${userId}`);
        return res.json({ success: true });
      } catch (firestoreErr) {
        console.error(`❌ Firestore write failed: ${firestoreErr.message}`);
        return res.status(500).json({ success: false, error: 'Firestore write failed' });
      }
    } else {
      console.warn(`⚠️ Payment not captured: ${paymentId} | Status: ${data.status}`);
      return res.json({ success: false });
    }
  } catch (err) {
    console.error('❌ Verification failed:', err.message);
    return res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/webhook', (req, res) => {
  res.send('✅ Webhook endpoint is live (but only accepts POST)');
});

// 🔐 Firebase setup from env
let serviceAccount;
try {
  serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
} catch (err) {
  console.error("❌ Failed to parse FIREBASE_SERVICE_ACCOUNT:", err.message);
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();

// 🧾 Razorpay setup
const mode = process.env.RAZORPAY_MODE || 'TEST';
const key_id = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_ID : process.env.RAZORPAY_TEST_KEY_ID;
const key_secret = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_SECRET : process.env.RAZORPAY_TEST_KEY_SECRET;

if (!key_id || !key_secret) {
  console.error("❌ Razorpay keys missing! Check your .env file.");
  process.exit(1);
}

const razorpay = new Razorpay({ key_id, key_secret });

// 🌍 Country detection from IP
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

// 📍 Country detection from GPS
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

// ✅ Test route
app.get('/test', (req, res) => {
  console.log('✅ /test route hit');
  res.send('✅ Test route is working');
});

// 🌐 Country detection route
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

// 🧾 Razorpay order creation
app.post('/create-order', async (req, res) => {
  try {
    const { amount, currency, receipt, userId, portalId } = req.body;
    console.log(`📦 Incoming order payload:`, req.body);

    if (!amount || isNaN(amount) || amount <= 0) {
      return res.status(400).json({ error: 'Invalid amount' });
    }

    const supportedCurrencies = ['INR', 'USD'];
    const finalCurrency = supportedCurrencies.includes(currency) ? currency : 'INR';

    const order = await razorpay.orders.create({
      amount: amount * 100,
      currency: finalCurrency,
      receipt: receipt || `receipt_${Date.now()}`,
      payment_capture: 1,
      notes: {
        userId,
        portalId,
      },
    });

    console.log(`✅ Order created: ${order.id} | Currency: ${order.currency}`);
    res.json(order);
  } catch (error) {
    console.error('❌ Order creation error:', error.message);
    res.status(500).json({ error: error.message });
  }
});

// 🔓 Razorpay payment verification + Firestore unlock
app.post('/verify-payment', async (req, res) => {
  const { paymentId, userId, portalId } = req.body;

  if (!paymentId || !userId || !portalId) {
    return res.status(400).json({ success: false, error: 'Missing required fields' });
  }

  try {
    const response = await fetch(`https://api.razorpay.com/v1/payments/${paymentId}`, {
      method: 'GET',
      headers: {
        Authorization: 'Basic ' + Buffer.from(`${key_id}:${key_secret}`).toString('base64'),
      },
    });

    const data = await response.json();

    if (data.status === 'captured') {
      console.log(`✅ Payment verified: ${paymentId}`);

      const userRef = db.collection('users').doc(userId);

      try {
        await userRef.set({}, { merge: true });
        await userRef.update({
          unlockedPortals: admin.firestore.FieldValue.arrayUnion(portalId),
          paymentHistory: admin.firestore.FieldValue.arrayUnion({
            paymentId,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            amount: data.amount ? data.amount / 100 : 0,
            currency: data.currency || 'INR',
            type: portalId,
            source: 'client',
          }),
        });

        console.log(`🔓 Portal ${portalId} unlocked and payment logged for user ${userId}`);
        return res.json({ success: true });
      } catch (firestoreErr) {
        console.error(`❌ Firestore write failed: ${firestoreErr.message}`);
        return res.status(500).json({ success: false, error: 'Firestore write failed' });
      }
    } else {
      console.warn(`⚠️ Payment not captured: ${paymentId} | Status: ${data.status}`);
      return res.json({ success: false });
    }
  } catch (err) {
    console.error('❌ Verification failed:', err.message);
    return res.status(500).json({ success: false, error: err.message });
  }
});

// 📡 Razorpay webhook for payment.captured
app.post('/webhook', async (req, res) => {
  const payload = req.body;
  const event = payload.event;

  console.log(`📡 Webhook received: ${event}`);

  if (event === 'payment.captured') {
    const payment = payload.payload.payment.entity;
    const paymentId = payment.id;
    const notes = payment.notes || {};
    const userId = notes.userId;
    const portalId = notes.portalId;

    if (!userId || !portalId) {
      console.warn(`⚠️ Missing userId or portalId in payment notes`);
      return res.status(400).send('Missing metadata');
    }

    try {
      const userRef = db.collection('users').doc(userId);
      await userRef.set({}, { merge: true });
      await userRef.update({
        unlockedPortals: admin.firestore.FieldValue.arrayUnion(portalId),
        paymentHistory: admin.firestore.FieldValue.arrayUnion({
          paymentId,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          amount: payment.amount ? payment.amount / 100 : 0,
          currency: payment.currency || 'INR',
          type: portalId,
          source: 'webhook',
        }),
      });

      console.log(`✅ Webhook: Portal ${portalId} unlocked for user ${userId}`);
      res.status(200).send('Success');
    } catch (err) {
      console.error(`❌ Webhook Firestore error: ${err.message}`);
      res.status(500).send('Firestore error');
    }
  } else {
    console.log(`ℹ️ Webhook event ignored: ${event}`);
    res.status(200).send('Ignored');
  }
});

// 🚀 Start server
const PORT = process.env.PORT || 3000;
console.log(`🛠️ PORT from environment: ${PORT}`);
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
// 🚀 Start server
const PORT = process.env.PORT || 3000;
console.log(`🛠️ PORT from environment: ${PORT}`);
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
