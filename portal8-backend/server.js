import express from "express";
import Razorpay from "razorpay";
import crypto from "crypto";
import bodyParser from "body-parser";
import cors from "cors";

const app = express();
const PORT = process.env.PORT || 10000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Razorpay instance
const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET,
});

// 🟢 Default root route
app.get("/", (req, res) => {
  res.send("✅ Portal8 backend is running");
});

// 🟢 Create Razorpay order
app.post("/create-order", async (req, res) => {
  try {
    const { amount, currency, receipt } = req.body;

    const options = {
      amount: amount * 100, // amount in paise
      currency: currency || "INR",
      receipt: receipt || "receipt#1",
    };

    const order = await razorpay.orders.create(options);
    console.log("✅ Order created:", order);
    res.json(order);
  } catch (error) {
    console.error("❌ Error creating order:", error);
    res.status(500).json({ error: "Failed to create order" });
  }
});

// 🟢 Verify payment
app.post("/verify-payment", (req, res) => {
  try {
    const { orderId, paymentId, signature } = req.body;

    const body = orderId + "|" + paymentId;
    const expectedSignature = crypto
      .createHmac("sha256", process.env.RAZORPAY_KEY_SECRET)
      .update(body.toString())
      .digest("hex");

    if (expectedSignature === signature) {
      console.log("✅ Payment verified:", paymentId);
      return res.json({ success: true, message: "Payment verified" });
    } else {
      console.warn("❌ Signature mismatch");
      return res.status(400).json({ success: false, message: "Invalid signature" });
    }
  } catch (error) {
    console.error("❌ Error verifying payment:", error);
    res.status(500).json({ success: false, message: "Verification failed" });
  }
});

// 🟢 Geo route
app.get("/geo", (req, res) => {
  res.json({
    ip: req.ip,
    country: req.headers["x-vercel-ip-country"] || "Unknown",
  });
});

// 🟢 IP route
app.get("/ip", (req, res) => {
  res.json({ ip: req.ip });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
