import express from "express";
import bcrypt from "bcrypt";
import db from "../db.js";

const router = express.Router();

router.get("/health", (_req, res) => {
  res.json({ status: "ok" });
});

router.post("/auth/login", async (req, res) => {
  const { email, password } = req.body || {};

  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  try {
    const [rows] = await db.execute(
      "SELECT id, email, password_hash, name FROM users WHERE email = ?",
      [email]
    );
    if (!rows.length) {
      return res.status(401).json({ error: "Invalid email or password" });
    }
    const user = rows[0];
    const valid = await bcrypt.compare(password, user.password_hash);
    if (!valid) {
      return res.status(401).json({ error: "Invalid email or password" });
    }
    const { password_hash, ...userWithoutPassword } = user;
    res.json({ success: true, user: userWithoutPassword });
  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({ error: "Database error" });
  }
});

export default router;
