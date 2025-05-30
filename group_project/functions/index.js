const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
app.use(cors({origin: true}));

const GOOGLE_API_KEY = "AIzaSyC0064ds-xg1CFwF946x6JQj00AsxB_lFo";

app.get("/autocomplete", async (req, res) => {
  const input = req.query.input;

  try {
    const response = await axios.get(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json",
        {
          params: {
            input,
            key: GOOGLE_API_KEY,
          },
        },
    );
    res.json(response.data);
  } catch (error) {
    console.error("Autocomplete error:", error);
    res.status(500).send("Error fetching autocomplete suggestions");
  }
});

// ✅ Export to Firebase (for Cloud Functions usage)
exports.api = functions.region("us-central1").https.onRequest(app);


// ✅ Optional: local test run (ONLY used if running outside Firebase)
if (require.main === module) {
  const PORT = process.env.PORT || 8080;
  app.listen(PORT, () => {
    console.log(`Server listening on http://localhost:${PORT}`);
  });
}
