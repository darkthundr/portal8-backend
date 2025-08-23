const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const firestore = admin.firestore();

// ---------- Razorpay HTTP Order Creation ----------
exports.createRazorpayOrder = functions.https.onRequest(async (req, res) => {
  try {
    // Only accept POST
    if (req.method !== "POST") {
      return res.status(405).send({ success: false, error: "Method not allowed" });
    }

    // Load env inside the function to avoid timeout
    const Razorpay = require("razorpay");
    require("dotenv").config();

    // Razorpay instance
    const mode = process.env.RAZORPAY_MODE || "TEST";
    const isLive = mode === "LIVE";

    const key_id = isLive
      ? process.env.RAZORPAY_LIVE_KEY_ID
      : process.env.RAZORPAY_TEST_KEY_ID;
    const key_secret = isLive
      ? process.env.RAZORPAY_LIVE_KEY_SECRET
      : process.env.RAZORPAY_TEST_KEY_SECRET;

    const razorpay = new Razorpay({ key_id, key_secret });

    // Request data
    const { country = "IN", bundle = false, portalIndex = null, uid } = req.body;

    // Pricing logic
    let currency = "INR";
    let amount = 0;

    if (country === "IN") {
      amount = bundle ? 999 : 199;
    } else {
      // For non-IN users, keep in INR but higher
      amount = bundle ? 2997 : 597;
    }

    const options = {
      amount: Math.round(amount * 100), // convert to paise
      currency,
      receipt: `receipt_${Date.now()}`,
    };

    // Create order
    const order = await razorpay.orders.create(options);

    // Save order in Firestore
    await firestore.collection("razorpay_orders").doc(order.id).set({
      uid,
      bundle,
      portalIndex,
      currency,
      country,
      amount,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(200).json({ success: true, order });
  } catch (error) {
    console.error("Razorpay Error:", error);
    res.status(500).json({ success: false, error: error.message });
  }
});
