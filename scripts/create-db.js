// loads env and imporst for file reading and mysql
import "dotenv/config";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";
import mysql from "mysql2/promise";
import bcrypt from "bcrypt"; // hashes passwords for secure storage
import { v4 as uuidv4 } from "uuid"; // generates unique ids for new records

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const TEMPDATA_DIR = path.join(__dirname, "..", "tempdata");

// skip rows that are headers or metadta (definitions, index labels) - only keep data rows
function isDataRow(applicationId) {
  if (!applicationId || typeof applicationId !== "string") return false;
  const trimmed = applicationId.trim();
  if (trimmed === "Application_id" || trimmed === "") return false;
  const metadataTerms = [
    "COLUMNS",
    "DEFINITION",
    "Relative index",
    "Low impact",
    "Moderate",
    "High",
  ];
  return !metadataTerms.some((term) =>
    trimmed.toLowerCase().includes(term.toLowerCase())
  );
}

// converts date string to mysql format (yyyy-mm-dd)
function parseDate(dateStr) {
  if (!dateStr || !dateStr.trim()) return null;
  const d = new Date(dateStr.trim());
  return isNaN(d.getTime()) ? null : d.toISOString().split("T")[0];
}

// parses value to int, retuns null for empty or invalid
function toInt(val) {
  if (val === "" || val === null || val === undefined) return null;
  const n = parseInt(String(val).replace(/,/g, ""), 10);
  return isNaN(n) ? null : n;
}

// parses to decimal, strips comma seperators
function toDecimal(val) {
  if (val === "" || val === null || val === undefined) return null;
  const n = parseFloat(String(val).replace(/,/g, ""));
  return isNaN(n) ? null : n;
}

// trims string and retuns null for empty
function toStr(val) {
  if (val === "" || val === null || val === undefined) return null;
  return String(val).trim() || null;
}

async function main() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD,
    multipleStatements: true,
  });

  try {
    // run the sql file to creat tables
    const sqlPath = path.join(__dirname, "simplan.sql");
    const sql = await fs.readFile(sqlPath, "utf-8");
    await connection.query(sql);
    console.log("Database and tables created.");

    await connection.changeUser({ database: "simplan" });

    // seed 2 placeholdr users with hashed paswords
    const hash1 = await bcrypt.hash("canada", 10);
    const hash2 = await bcrypt.hash("password", 10);
    await connection.execute(
      "INSERT INTO users (id, email, password_hash, name) VALUES (?, ?, ?, ?), (?, ?, ?, ?)",
      [
        uuidv4(),
        "mark.carney@gmail.com",
        hash1,
        "Mark Carney",
        uuidv4(),
        "daniel.moreau@gmail.com",
        hash2,
        "Daniel Moreau",
      ]
    );
    console.log("Placeholder users created:");
    console.log("  mark.carney@gmail.com / canada");
    console.log("  daniel.moreau@gmail.com / password");

    // import base_planning from csv - reads file and inserts each row
    const basePath = path.join(
      TEMPDATA_DIR,
      "SIMPLAN DATA - Base_planning(important).csv"
    );
    const baseCsv = await fs.readFile(basePath, "utf-8");
    const baseLines = baseCsv.split("\n").filter((l) => l.trim());
    const baseHeader = baseLines[0];
    const baseCols = baseHeader.split(",").map((c) => c.trim());

    for (let i = 1; i < baseLines.length; i++) {
      const cols = baseLines[i].split(",").map((c) => c.trim());
      const applicationId = toStr(cols[0]);
      if (!isDataRow(applicationId)) continue;

      await connection.execute(
        `INSERT INTO base_planning (
          application_id, submission_date, district_id, district_name,
          proposed_use, max_storeys, residential_units, non_residential_gfa_m2,
          inside_mtsa, mtsa_corridor, distance_to_transit_m, approval_score, synthetic_approval
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          applicationId,
          parseDate(cols[1]),
          toInt(cols[2]),
          toStr(cols[3]),
          toStr(cols[4]),
          toInt(cols[5]),
          toInt(cols[6]),
          toDecimal(cols[7]),
          toInt(cols[8]),
          toStr(cols[9]),
          toInt(cols[10]),
          toInt(cols[11]),
          toInt(cols[12]),
        ]
      );
    }
    console.log(`Imported ${baseLines.length - 1} base_planning rows.`);

    // import social economic scores - joins to base via application_id
    const socialPath = path.join(
      TEMPDATA_DIR,
      "SIMPLAN DATA - Social_Economic_Scores.csv"
    );
    const socialCsv = await fs.readFile(socialPath, "utf-8");
    const socialLines = socialCsv.split("\n").filter((l) => l.trim());
    let socialCount = 0;
    for (let i = 1; i < socialLines.length; i++) {
      const cols = socialLines[i].split(",").map((c) => c.trim());
      const applicationId = toStr(cols[0]);
      if (!isDataRow(applicationId)) continue;

      await connection.execute(
        `INSERT INTO social_economic_scores (
          application_id, rent_increase_forecast_pct, rent_burden_score,
          displacement_risk_score, transit_speed_impact_score
        ) VALUES (?, ?, ?, ?, ?)`,
        [
          applicationId,
          toDecimal(cols[1]),
          toInt(cols[2]),
          toInt(cols[3]),
          toInt(cols[4]),
        ]
      );
      socialCount++;
    }
    console.log(`Imported ${socialCount} social_economic_scores rows.`);

    // import finacial scores - default risk, loan feasability etc
    const financialPath = path.join(
      TEMPDATA_DIR,
      "SIMPLAN DATA - Financial_Score.csv"
    );
    const financialCsv = await fs.readFile(financialPath, "utf-8");
    const financialLines = financialCsv.split("\n").filter((l) => l.trim());
    let financialCount = 0;
    for (let i = 1; i < financialLines.length; i++) {
      const cols = financialLines[i].split(",").map((c) => c.trim());
      const applicationId = toStr(cols[0]);
      if (!isDataRow(applicationId)) continue;

      await connection.execute(
        `INSERT INTO financial_scores (
          application_id, property_value_change_pct, default_risk_score,
          capital_concentration_risk, construction_loan_feasibility, insurance_premium_shift_index
        ) VALUES (?, ?, ?, ?, ?, ?)`,
        [
          applicationId,
          toDecimal(cols[1]),
          toInt(cols[2]),
          toInt(cols[3]),
          toInt(cols[4]),
          toInt(cols[5]),
        ]
      );
      financialCount++;
    }
    console.log(`Imported ${financialCount} financial_scores rows.`);

    // import urban impact - population, traffic, enviornment
    const urbanPath = path.join(
      TEMPDATA_DIR,
      "SIMPLAN DATA - Urban_Impact_Score.csv"
    );
    const urbanCsv = await fs.readFile(urbanPath, "utf-8");
    const urbanLines = urbanCsv.split("\n").filter((l) => l.trim());
    let urbanCount = 0;
    for (let i = 1; i < urbanLines.length; i++) {
      const cols = urbanLines[i].split(",").map((c) => c.trim());
      const applicationId = toStr(cols[0]);
      if (!isDataRow(applicationId)) continue;

      await connection.execute(
        `INSERT INTO urban_impact_scores (
          application_id, projected_population_increase, traffic_delta_pct,
          environmental_stress_change, shadow_impact_score, transit_rider_impact, estimated_new_riders_daily
        ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [
          applicationId,
          toInt(cols[1]),
          toDecimal(cols[2]),
          toInt(cols[3]),
          toInt(cols[4]),
          toInt(cols[5]),
          toInt(cols[6]),
        ]
      );
      urbanCount++;
    }
    console.log(`Imported ${urbanCount} urban_impact_scores rows.`);

    console.log("Database setup complete.");
  } finally {
    await connection.end();
  }
}

// run main and exit on erorr
main().catch((err) => {
  console.error(err);
  process.exit(1);
});
