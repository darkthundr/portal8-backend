const express = require('express');
const Razorpay = require('razorpay');
const axios = require('axios');
require('dotenv').config();

const app = express();
app.use(express.json());

// Razorpay setup
const mode = process.env.RAZORPAY_MODE || 'TEST';
const key_id = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_ID : process.env.RAZORPAY_TEST_KEY_ID;
const key_secret = mode === 'LIVE' ? process.env.RAZORPAY_LIVE_KEY_SECRET : process.env.RAZORPAY_TEST_KEY_SECRET;

if (!key_id || !key_secret) {
  console.error("❌ Razorpay keys missing! Check your .env file.");
  process.exit(1);
}

const razorpay = new Razorpay({ key_id, key_secret });

// Health check route
app.get('/ping', (req, res) => {
  res.send('✅ Server is alive');
});

// Create Razorpay order
app.post('/create-razorpay-order', async (req, res) => {
  const { amountINR } = req.body;

  if (!amountINR || isNaN(amountINR)) {
    return res.status(400).json({ error: 'Invalid amount' });
  }

  try {
    const order = await razorpay.orders.create({
      amount: amountINR * 100, // Convert to paise
      currency: 'INR',
      receipt: `receipt_${Date.now()}`,
      payment_capture: 1,
    });

    console.log('✅ Razorpay order created:', order.id);
    res.json(order);
  } catch (err) {
    console.error('❌ Error creating Razorpay order:', err);
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));