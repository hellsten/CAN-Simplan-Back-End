import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken"; // signs tokens so client can prove they logged in
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

    // creats a signed token with user id/email, expires in 7 days
    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    res.json({ success: true, user: userWithoutPassword, token });
  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({ error: "Database error" });
  }
});

export default router;
