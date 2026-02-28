import "dotenv/config";
import cors from "cors";
import express from "express";

import authRoutes from "./routes/auth.js";
import proposalsRoutes from "./routes/proposals.js";
import dashboardRoutes from "./routes/dashboard.js";

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api", authRoutes);
app.use("/api", proposalsRoutes);
app.use("/api", dashboardRoutes);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`SIMPLAN Backend running on port ${PORT}`);
});
