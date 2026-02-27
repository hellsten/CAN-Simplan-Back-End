import 'dotenv/config'
import cors from "cors";
import express from "express";

const app = express();

app.use(cors());
app.use(express.json());

app.get("/api/health", (_req, res) => {
  res.json({ status: "ok" });
});


const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`SIMPLAN Backend running on port ${PORT}`);
});
