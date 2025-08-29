const express = require('express');
const Razorpay = require('razorpay');
const cors = require('cors');
const fetch = require('node-fetch');
const admin = require('firebase-admin');
const bodyParser = require('body-parser');
const crypto = require('crypto');
const path = require('path');
require('dotenv').config();

const app = express();
app.use(cors());

// 👀 Skip webhook from JSON parsing (must remain raw)
app.use((req, res, next) => {
  if (req.originalUrl === '/webhook') {
    next();
  } else {
    express.json()(req, res, next);
  }
});

// 🔐 Firebase setup
let serviceAccount;
try {
  if (process.env.FIREBASE_SERVICE_ACCOUNT_FILE) {
    // Load JSON from project root
    serviceAccount = require(path.join(__dirname, process.env.FIREBASE_SERVICE_ACCOUNT_FILE));
  } else if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    // Load JSON from env variable
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  } else {
    throw new Error("No Firebase service account provided");
  }
} catch (err) {
  console.error("❌ Failed to load Firebase service account:", err.message);
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();

// 🧾 Razorpay setup
const mode = process.env.RAZORPAY_MODE || 'TEST';
const key_id =
  mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_ID : process.env.RAZORPAY_TEST_KEY_ID;
const key_secret =
  mode === 'LIVE'
    ? process.env.RAZORPAY_LIVE_KEY_SECRET
    : process.env.RAZORPAY_TEST_KEY_SECRET;

const razorpay = new Razorpay({ key_id, key_secret });

/* ------------------------------------------------------------------
   🌍 Country Detection Helpers
------------------------------------------------------------------ */
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

async function getCountryFromLocation(lat, lng) {
  try {
    const key = process.env.OPENCAGE_KEY;
    const res = await fetch(
      `https://api.opencagedata.com/geocode/v1/json?q=${lat}+${lng}&key=${key}`
    );
    const data = await res.json();
    return data.results?.[0]?.components?.country_code?.toUpperCase() || null;
  } catch (err) {
    console.error('📍 GPS lookup failed:', err.message);
    return null;
  }
}

/* ------------------------------------------------------------------
   ✅ Routes
------------------------------------------------------------------ */
app.get('/', (req, res) => {
  res.send('✅ Razorpay backend running');
});

app.get('/geo', async (req, res) => {
  try {
    const { lat, lng } = req.query;
    let country = null;

    if (lat && lng) country = await getCountryFromLocation(lat, lng);

    if (!country) {
      const ip =
        req.headers['x-forwarded-for']?.split(',')[0] || req.ip || '8.8.8.8';
      country = await getCountryFromIP(ip);
    }

    res.json({ country });
  } catch (err) {
    console.error('❌ /geo failed:', err.message);
    res.status(200).json({ country: 'IN', fallback: true });
  }
});

// 🧾 Create Razorpay Order
app.post('/create-order', async (req, res) => {
  try {
    const { amount, currency, receipt, userId, portalId } = req.body;

    if (!amount || !userId || !portalId) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const finalCurrency = ['INR', 'USD'].includes(currency) ? currency : 'INR';

    const order = await razorpay.orders.create({
      amount: amount * 100, // paise
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

// 🔓 Verify Razorpay Payment
app.post('/verify-payment', async (req, res) => {
  const { orderId, paymentId, signature, userId, portalId } = req.body;

  if (!orderId || !paymentId || !signature || !userId || !portalId) {
    return res.status(400).json({ success: false, error: 'Missing fields' });
  }

  try {
    const expectedSignature = crypto
      .createHmac('sha256', key_secret)
      .update(orderId + "|" + paymentId)
      .digest('hex');

    if (expectedSignature !== signature) {
      return res.status(400).json({ success: false, error: 'Invalid signature' });
    }

    const userRef = db.collection('users').doc(userId);
    await userRef.set({}, { merge: true });
    await userRef.update({
      unlockedPortals: admin.firestore.FieldValue.arrayUnion(portalId),
      paymentHistory: admin.firestore.FieldValue.arrayUnion({
        orderId,
        paymentId,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        type: portalId,
        source: 'client-verify',
      }),
    });

    res.json({ success: true });
  } catch (err) {
    console.error('❌ Verification error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// 📡 Razorpay Webhook (server-to-server)
app.post('/webhook', bodyParser.raw({ type: 'application/json' }), async (req, res) => {
  try {
    const payload = JSON.parse(req.body.toString());

    if (payload.event !== 'payment.captured') return res.status(200).send('Ignored');

    const payment = payload.payload.payment.entity;
    const { userId, portalId } = payment.notes || {};

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

/* ------------------------------------------------------------------
   🚀 Start server
------------------------------------------------------------------ */
const PORT = process.env.PORT || 10000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
