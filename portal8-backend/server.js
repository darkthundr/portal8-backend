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

if (!key_id || !key_secret) {
  console.error("❌ Razorpay keys missing!");
  process.exit(1);
}
const razorpay = new Razorpay({ key_id, key_secret });

// ✅ Test route
app.get('/test', (req, res) => {
  console.log('✅ /test route hit');
  res.send('✅ Server is live');
});

// 🧾 Order creation
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

    console.log(`✅ Order created: ${order.id}`);
    res.json(order);
  } catch (err) {
    console.error('❌ Order creation error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

// 🔓 Payment verification
app.post('/verify-payment', async (req, res) => {
  const { paymentId, userId, portalId } = req.body;
  if (!paymentId || !userId || !portalId) {
    return res.status(400).json({ success: false, error: 'Missing fields' });
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
      console.log(`🔓 Verified: Portal ${portalId} unlocked for user ${userId}`);
      return res.json({ success: true });
    } else {
      console.warn(`⚠️ Payment not captured: ${paymentId}`);
      return res.json({ success: false });
    }
  } catch (err) {
    console.error('❌ Verification error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// 📡 Razorpay webhook (raw body parser required)
app.post('/webhook', bodyParser.raw({ type: 'application/json' }), async (req, res) => {
  try {
    const payload = JSON.parse(req.body.toString());
    console.log('📡 Webhook received:', payload);

    const event = payload.event;
    if (event !== 'payment.captured') return res.status(200).send('Ignored');

    const payment = payload.payload.payment.entity;
    const notes = payment.notes || {};
    const userId = notes.userId;
    const portalId = notes.portalId;

    if (!userId || !portalId) {
      console.warn('⚠️ Missing metadata');
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

    console.log(`✅ Webhook: Portal ${portalId} unlocked for user ${userId}`);
    res.status(200).send('Success');
  } catch (err) {
    console.error('❌ Webhook error:', err.message);
    res.status(500).send('Webhook failed');
  }
});

// 🚀 Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
