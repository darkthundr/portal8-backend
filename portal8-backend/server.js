const express = require('express');
const Razorpay = require('razorpay');
const cors = require('cors');
const crypto = require('crypto');
require('dotenv').config();

const app = express();
app.use(cors());

// ------------------ Webhook Listener (must come before express.json) ------------------
app.post('/razorpay-webhook', express.raw({ type: 'application/json' }), (req, res) => {
  const signature = req.headers['x-razorpay-signature'];
  const rawBody = req.body.toString();

  const expectedSignature = crypto
    .createHmac('sha256', process.env.RAZORPAY_WEBHOOK_SECRET)
    .update(rawBody)
    .digest('hex');

  if (signature !== expectedSignature) {
    console.warn('❌ Invalid webhook signature');
    return res.status(400).send('Invalid signature');
  }

  let eventData;
  try {
    eventData = JSON.parse(rawBody);
  } catch (err) {
    console.error('❌ Failed to parse webhook body:', err);
    return res.status(400).send('Invalid JSON');
  }

  const event = eventData.event;
  const payload = eventData.payload;

  console.log(`📬 Webhook Event: ${event}`);

  if (event === 'payment.captured') {
    const paymentId = payload.payment.entity.id;
    const email = payload.payment.entity.email;
    console.log(`✅ Payment captured: ${paymentId} for ${email}`);
    // TODO: Unlock content or update database here
  }

  res.status(200).send('Webhook received');
});

// ------------------ Apply JSON Middleware AFTER webhook ------------------
app.use(express.json());

// ------------------ Select Keys Based on Mode ------------------
const mode = process.env.RAZORPAY_MODE || 'TEST';
const key_id = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_ID : process.env.RAZORPAY_TEST_KEY_ID;
const key_secret = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_SECRET : process.env.RAZORPAY_TEST_KEY_SECRET;
const webhook_secret = process.env.RAZORPAY_WEBHOOK_SECRET;

// ------------------ Environment Debug ------------------
console.log(`🔑 Razorpay Mode: ${mode}`);
console.log(`🔐 Key ID: ${key_id ? key_id : '❌ Missing'}`);
console.log(`🔐 Key Secret: ${key_secret ? '✅ Loaded' : '❌ Missing'}`);
console.log(`📬 Webhook Secret: ${webhook_secret ? '✅ Loaded' : '❌ Missing'}`);

if (!key_id || !key_secret) {
  console.error("❌ Razorpay keys missing! Check your .env file.");
  process.exit(1);
}

const razorpay = new Razorpay({ key_id, key_secret });

// ------------------ Health Check ------------------
app.get('/', (req, res) => {
  res.send('✅ Server is running');
});

// ------------------ Create Order ------------------
app.post('/create-order', async (req, res) => {
  const { amount, currency = 'INR', receipt = `receipt_${Date.now()}` } = req.body;

  if (!amount || isNaN(amount)) {
    return res.status(400).json({ error: 'Invalid amount' });
  }

  try {
    const order = await razorpay.orders.create({
      amount: amount * 100, // Convert to paise
      currency,
      receipt,
      payment_capture: 1,
    });

    console.log(`✅ Razorpay Order Created: ${order.id}`);
    res.json(order);
  } catch (error) {
    console.error('❌ Error creating order:', error);
    res.status(500).json({ error: error.message });
  }
});

// ------------------ Test Route ------------------
app.post('/test', (req, res) => {
  res.json({ message: '✅ POST /test is working' });
});

// ------------------ Start Server ------------------
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
