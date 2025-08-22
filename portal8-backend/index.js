const express = require('express');
const Razorpay = require('razorpay');
const axios = require('axios');
require('dotenv').config();

const app = express();
app.use(express.json());

// Razorpay setup
const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_MODE === 'LIVE'
    ? process.env.RAZORPAY_LIVE_KEY_ID
    : process.env.RAZORPAY_TEST_KEY_ID,
  key_secret: process.env.RAZORPAY_MODE === 'LIVE'
    ? process.env.RAZORPAY_LIVE_KEY_SECRET
    : process.env.RAZORPAY_TEST_KEY_SECRET,
});

// Create Razorpay order
app.post('/create-razorpay-order', async (req, res) => {
  const { amountINR } = req.body;
  try {
    const order = await razorpay.orders.create({
      amount: amountINR * 100,
      currency: 'INR',
      receipt: `receipt_${Date.now()}`,
    });
    res.json(order);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});



app.listen(3000, () => console.log('🚀 Server running on port 3000'));