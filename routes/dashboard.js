import express from "express";
import db from "../db.js";

const router = express.Router();

router.get("/dashboard", async (_req, res) => {
  try {
    const [countRows] = await db.execute(
      "SELECT COUNT(*) as total FROM base_planning"
    );
    const recordCount = countRows[0]?.total ?? 0;

    res.json({
      simulationModel: "Mississauga",
      version: "v1.2",
      lastUpdated: "2026-01-15",
      datasetName: "Mississauga Dev Apps",
      recordCount,
      simulationStatus: "Live Simulation",
    });
  } catch (err) {
    console.error("Dashboard error:", err);
    res.status(500).json({ error: "Database error" });
  }
});

export default router;
