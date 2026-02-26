import dotenv from "dotenv/config";
//dotenv.config();

import express from "express";
import cors from "cors";
import { v4 as uuidv4 } from "uuid";
import connection from "./utils/database.js";

const app = express();
const PORT = process.env.PORT || 5050;

app.use(cors());
app.use(express.json());

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));