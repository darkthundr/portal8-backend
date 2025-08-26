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

// 🔐 Firebase setup
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
  res.send('✅ Server is live');
});

// 🌐 Country detection route
app.get('/geo', async (req, res) => {
  try {
    const { lat, lng } = req.query;
    let country = null;

    if (lat && lng) {
      country = await getCountryFromLocation(lat, lng);
    }

    if (!country) {
      const ip = req.headers['x-forwarded-for']?.split(',')[0] || req.connection.remoteAddress || '8.8.8.8';
      country = await getCountryFromIP(ip);
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

    if (!amount || !userId || !portalId) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const finalCurrency = ['INR', 'USD'].includes(currency) ? currency : 'INR';

    const order = await razorpay.orders.create({
      amount: amount * 100,
      currency: finalCurrency,
      receipt: receipt || `receipt_${Date.now()}`,
      payment_capture: 1,
      notes: { userId, portalId },
    });

    res.json(order);
  } catch (error) {
    console.error('❌ Order creation error:', error.message);
    res.status(500).json({ error: error.message });
  }
});

// 🔓 Razorpay payment verification
app.post('/verify-payment', async (req, res) => {
  const { paymentId, userId, portalId } = req.body;

  if (!paymentId || !userId || !portalId) {
    return res.status(400).json({ success: false, error: 'Missing fields' });
  }
console.log('🔍 /verify-payment route hit');
  try {
    const response = await fetch(`https://api.razorpay.com/v1/payments/${paymentId}`, {
      method: 'GET',
      headers: {
        Authorization: 'Basic ' + Buffer.from(`${key_id}:${key_secret}`).toString('base64'),
      },
    });

    const data = await response.json();

    if (data.status === 'captured') {
      const userRef = db.collection('users').doc(userId);
      await userRef.set({}, { merge: true });
      await userRef.update({
        unlockedPortals: admin.firestore.FieldValue.arrayUnion(portalId),
        paymentHistory: admin.firestore.FieldValue.arrayUnion({
          paymentId,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          amount: data.amount / 100,
          currency: data.currency,
          type: portalId,
          source: 'client',
        }),
      });

      return res.json({ success: true });
    } else {
      return res.json({ success: false });
    }
  } catch (err) {
    console.error('❌ Verification error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// 📡 Razorpay webhook route (raw body parser required)

app.post('/webhook', bodyParser.raw({ type: 'application/json' }), async (req, res) => {
  try {
    const payload = JSON.parse(req.body.toString());

    if (payload.event !== 'payment.captured') return res.status(200).send('Ignored');

    const payment = payload.payload.payment.entity;
    const notes = payment.notes || {};
    const userId = notes.userId;
    const portalId = notes.portalId;

    if (!userId || !portalId) {
      return res.status(400).send('Missing metadata');
    }

    const userRef = db.collection('users').doc(userId);
    await userRef.set({}, { merge: true });
    await userRef.update({
      unlockedPortals: admin.firestore.FieldValue.arrayUnion(portalId),
      paymentHistory: admin.firestore.FieldValue.arrayUnion({
        paymentId: payment.id,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        amount: payment.amount / 100,
        currency: payment.currency,
        type: portalId,
        source: 'webhook',
      }),
    });

    res.status(200).send('Success');
  } catch (err) {
    console.error('❌ Webhook error:', err.message);
    res.status(500).send('Webhook failed');
  }
});

const PORT = process.env.PORT || 10000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
