const express = require('express');
const Razorpay = require('razorpay');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// ------------------ Select Keys Based on Mode ------------------
const mode = process.env.RAZORPAY_MODE || 'TEST';
let key_id, key_secret;

if (mode === 'LIVE') {
  key_id = process.env.RAZORPAY_LIVE_KEY_ID;
  key_secret = process.env.RAZORPAY_LIVE_KEY_SECRET;
} else {
  key_id = process.env.RAZORPAY_TEST_KEY_ID;
  key_secret = process.env.RAZORPAY_TEST_KEY_SECRET;
}

// ------------------ Environment Debug ------------------
console.log('Razorpay Mode:', mode);
console.log('Using Key ID:', key_id ? key_id : '❌ Missing');
console.log('Using Key Secret:', key_secret ? '✅ Loaded' : '❌ Missing');

if (!key_id || !key_secret) {
  console.error("❌ Razorpay keys missing! Check your .env file.");
  process.exit(1);
}

// ------------------ Razorpay Init ------------------
const razorpay = new Razorpay({
  key_id,
  key_secret,
});

// ------------------ Health Check Route ------------------
app.get('/', (req, res) => {
  res.send('✅ Server is running');
});

// ------------------ Create Order Route ------------------
app.post('/create-order', async (req, res) => {
  try {
    const { amount, currency = 'INR', receipt = `receipt_${Date.now()}` } = req.body;

    if (!amount || isNaN(amount)) {
      return res.status(400).json({ error: 'Invalid amount' });
    }

    const options = {
      amount: amount * 100, // Convert to paise
      currency,
      receipt,
      payment_capture: 1,
    };

    const order = await razorpay.orders.create(options);
    console.log('✅ Order created:', order.id);
    res.json(order);
  } catch (error) {
    console.error('❌ Order creation error:', error);
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