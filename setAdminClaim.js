const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json"); // ✅ Path to your key

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const uid = "I9Gc54UfptS5QM4w9dJsjUbMvFH3"; // Your UID

admin.auth().setCustomUserClaims(uid, { admin: true })
  .then(() => {
    console.log(`✅ Admin claim set for UID: ${uid}`);
  })
  .catch((error) => {
    console.error("❌ Error setting admin claim:", error);
  });