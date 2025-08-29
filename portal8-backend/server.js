// server.js
import express from "express";
import Razorpay from "razorpay";
import crypto from "crypto";
import cors from "cors";

const app = express();
app.use(cors());
app.use(express.json());

// ✅ Razorpay instance
const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID || "rzp_test_R8SPavSwbFwtFT",
  key_secret: process.env.RAZORPAY_KEY_SECRET || "Pg6KUonAlGPXbUU51FA4hKKN",
});

// ✅ Test route
app.get("/", (req, res) => {
  res.send("✅ Portal 8 backend is live!");
});

// ✅ Create Order
app.post("/create-order", async (req, res) => {
  try {
    const { amount, currency, receipt } = req.body;

    const options = {
      amount: amount * 100, // Razorpay works in paise
      currency: currency || "INR",
      receipt: receipt || "receipt#1",
    };

    const order = await razorpay.orders.create(options);
    console.log("✅ Order created:", order);
    res.json(order);
  } catch (err) {
    console.error("❌ Order creation failed:", err);
    res.status(500).json({ error: "Failed to create order" });
  }
});

// ✅ Verify Payment
app.post("/verify-payment", (req, res) => {
  try {
    const { orderId, paymentId, signature } = req.body;

    const body = orderId + "|" + paymentId;

    const expectedSignature = crypto
      .createHmac("sha256", process.env.RAZORPAY_KEY_SECRET || "your_secret_here")
      .update(body.toString())
      .digest("hex");

    if (expectedSignature === signature) {
      console.log("✅ Payment verified:", { orderId, paymentId });
      res.json({ success: true, message: "Payment verified successfully" });
    } else {
      console.log("❌ Invalid signature:", signature);
      res.status(400).json({ success: false, message: "Invalid signature" });
    }
  } catch (err) {
    console.error("❌ Verification error:", err);
    res.status(500).json({ error: "Payment verification failed" });
  }
});

// ✅ Server Listen
const PORT = process.env.PORT || 10000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
