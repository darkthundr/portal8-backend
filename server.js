const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const Stripe = require('stripe');
const Razorpay = require('razorpay');
const axios = require('axios');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Stripe setup
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

// Razorpay setup
const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET
});

// ---- Stripe PaymentIntent for international users ----
app.post('/create-stripe-intent', async (req, res) => {
  const { amountUSD } = req.body;
  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amountUSD * 100),
      currency: 'usd',
      automatic_payment_methods: { enabled: true },
    });
    res.send({ clientSecret: paymentIntent.client_secret });
  } catch (err) {
    res.status(500).send({ error: err.message });
  }
});

// ---- Razorpay Order for Indian users ----
app.post('/create-razorpay-order', async (req, res) => {
  const { amountINR } = req.body;
  const options = {
    amount: amountINR * 100,
    currency: 'INR',
    receipt: `receipt_${Date.now()}`,
  };
  try {
    const order = await razorpay.orders.create(options);
    res.send(order);
  } catch (err) {
    res.status(500).send({ error: err.message });
  }
});

// ---- PayPal Order for international users ----
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
          'Authorization': `Basic ${auth}`,
          'Content-Type': 'application/x-www-form-urlencoded'
        }
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
            value: amountUSD.toFixed(2)
          }
        }]
      },
      {
        headers: {
          'Authorization': `Bearer ${accessToken}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const approveUrl = orderRes.data.links.find(link => link.rel === 'approve')?.href;

    if (!approveUrl) {
      throw new Error("Missing approval URL from PayPal response");
    }

    res.json({
      orderID: orderRes.data.id,
      approveUrl
    });
  } catch (err) {
    console.error("PayPal Error:", err.response?.data || err.message);
    res.status(500).json({ error: "Failed to create PayPal order" });
  }
});

app.listen(3000, () => console.log('🚀 Backend running on http://localhost:3000'));