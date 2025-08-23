// index.js
const express = require("express");
const Razorpay = require("razorpay");
const bodyParser = require("body-parser");
const cors = require("cors");
require("dotenv").config();

app.get("/", (req, res) => {
  res.send("✅ Server is running");
});

const app = express();
app.use(bodyParser.json());
app.use(cors());

const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET,
});

// Create Razorpay order
app.post("/create-order", async (req, res) => {
  try {
    const { amount } = req.body; // in paise (100 INR = 10000)
    const options = {
      amount,
      currency: "INR",
      receipt: `rcpt_${Date.now()}`
    };
    const order = await razorpay.orders.create(options);
    res.json(order);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

<<<<<<< HEAD


app.listen(3000, () => console.log('🚀 Server running on port 3000'));
=======
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
>>>>>>> befab305da063a27dbdea61dac043704e8828b90
