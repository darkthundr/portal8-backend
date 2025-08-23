// mini-server.js
const express = require('express');
const Razorpay = require('razorpay');
const app = express();
app.use(express.json());

// ✅ Razorpay test credentials (replace with .env in production)
const razorpay = new Razorpay({
  key_id: 'rzp_test_R8SPavSwbFwtFT',
  key_secret: 'Pg6KUonAlGPXbUU51FA4hKKN',
});

// 🔍 Health check route
app.post('/test', (req, res) => {
  console.log('✅ /test route hit');
  res.json({ message: 'POST /test is working!' });
});

// 💳 Razorpay order creation route
app.post('/createorder', async (req, res) => {
  try {
    const { amount, currency = 'INR' } = req.body;

    if (!amount || isNaN(amount)) {
      return res.status(400).json({ error: 'Invalid amount' });
    }

    const options = {
      amount: amount * 100, // Convert to paise
      currency,
      receipt: `receipt_${Date.now()}`,
      payment_capture: 1,
    };

    const order = await razorpay.orders.create(options);
    console.log('✅ Order created:', order.id);
    res.json({
      success: true,
      order_id: order.id,
      amount: order.amount,
      currency: order.currency,
    });
  } catch (error) {
    console.error('❌ Order creation error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// 🚀 Start server
app.listen(4000, () => {
  console.log('🚀 Mini server running on port 4000');
});