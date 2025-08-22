const express = require('express');
const Razorpay = require('razorpay');
const axios = require('axios');
require('dotenv').config();

const app = express();
app.use(express.json());

// ---------- Razorpay Setup ----------
const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_MODE === 'LIVE'
    ? process.env.RAZORPAY_LIVE_KEY_ID
    : process.env.RAZORPAY_TEST_KEY_ID,
  key_secret: process.env.RAZORPAY_MODE === 'LIVE'
    ? process.env.RAZORPAY_LIVE_KEY_SECRET
    : process.env.RAZORPAY_TEST_KEY_SECRET,
});

// ---------- Razorpay Order Creation ----------
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
    console.error("Razorpay Error:", err.message);
    res.status(500).json({ error: err.message });
  }
});

// ---------- PayPal Order Creation ----------
app.post('/create-paypal-order', async (req, res) => {
  const { amountUSD, mode } = req.body;
  const isLive = mode === 'RELEASE';

  const clientId = isLive
    ? process.env.PAYPAL_LIVE_CLIENT_ID
    : process.env.PAYPAL_SANDBOX_CLIENT_ID;

  const clientSecret = isLive
    ? process.env.PAYPAL_LIVE_SECRET
    : process.env.PAYPAL_SANDBOX_SECRET;

  const baseUrl = isLive
    ? 'https://api-m.paypal.com'
    : 'https://api-m.sandbox.paypal.com';

  try {
    const auth = Buffer.from(`${clientId}:${clientSecret}`).toString('base64');

    const tokenRes = await axios.post(
      `${baseUrl}/v1/oauth2/token`,
      'grant_type=client_credentials',
      {
        headers: {
          Authorization: `Basic ${auth}`,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      }
    );

    const accessToken = tokenRes.data.access_token;

    const orderRes = await axios.post(
      `${baseUrl}/v2/checkout/orders`,
      {
        intent: 'CAPTURE',
        purchase_units: [{
          amount: {
            currency_code: 'USD',
            value: amountUSD.toFixed(2),
          },
        }],
        application_context: {
          return_url: 'https://portal8.onrender.com/paypal-success',
          cancel_url: 'https://portal8.onrender.com/paypal-cancel',
          brand_name: 'Portal8',
          user_action: 'PAY_NOW',
        },
      },
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
      }
    );

    const approveUrl = orderRes.data.links.find(link => link.rel === 'approve')?.href;

    res.json({
      orderID: orderRes.data.id,
      approveUrl,
    });
  } catch (err) {
    console.error("PayPal Order Error:", err.message);
    res.status(500).json({ error: err.message });
  }
});

// ---------- PayPal Success Route with Capture ----------
app.get('/paypal-success', async (req, res) => {
  const token = req.query.token;
  if (!token) return res.status(400).send('Missing token');

  const isLive = process.env.PAYPAL_MODE === 'LIVE';
  const clientId = isLive
    ? process.env.PAYPAL_LIVE_CLIENT_ID
    : process.env.PAYPAL_SANDBOX_CLIENT_ID;
  const clientSecret = isLive
    ? process.env.PAYPAL_LIVE_SECRET
    : process.env.PAYPAL_SANDBOX_SECRET;
  const baseUrl = isLive
    ? 'https://api-m.paypal.com'
    : 'https://api-m.sandbox.paypal.com';

  try {
    const auth = Buffer.from(`${clientId}:${clientSecret}`).toString('base64');

    const tokenRes = await axios.post(
      `${baseUrl}/v1/oauth2/token`,
      'grant_type=client_credentials',
      {
        headers: {
          Authorization: `Basic ${auth}`,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      }
    );

    const accessToken = tokenRes.data.access_token;

    const captureRes = await axios.post(
      `${baseUrl}/v2/checkout/orders/${token}/capture`,
      {},
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
      }
    );

    res.send(`
      <h1>✅ Payment Captured</h1>
      <p>Your portals will unlock shortly. You may now return to the app.</p>
    `);
  } catch (err) {
    console.error("Capture Error:", err.message);
    res.status(500).send("Payment capture failed");
  }
});

// ---------- PayPal Cancel Route ----------
app.get('/paypal-cancel', (req, res) => {
  res.send(`
    <h1>❌ Payment Cancelled</h1>
    <p>No worries. You can try again anytime.</p>
  `);
});

// ---------- Server Start ----------
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
