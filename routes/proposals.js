import express from "express";
import db from "../db.js";

const router = express.Router();

function scoreToLabel(score) {
  if (score === null || score === undefined) return "Low";
  const n = Number(score);
  if (n <= 30) return "Low";
  if (n <= 70) return "Moderate";
  return "High";
}

function rowToProposal(r) {
  const urban = r.approval_score ?? 0;
  const financial = scoreToLabel(r.default_risk_score);
  const displacement = scoreToLabel(r.displacement_risk_score);
  const status = r.synthetic_approval === 1 ? "Clear to Proceed" : "Review";

  return {
    id: r.application_id,
    referenceId: r.application_id,
    applicantDistrict: r.district_name,
    district: r.district_name,
    use: r.proposed_use,
    date: r.submission_date ? r.submission_date.toISOString().split("T")[0] : null,
    urban,
    urbanDisplay: `${urban}/100`,
    financial,
    displacement,
    status,
  };
}

router.get("/proposals", async (req, res) => {
  try {
    const { status, sortBy, sortOrder, search } = req.query;

    let sql = `
      SELECT 
        bp.application_id,
        bp.submission_date,
        bp.district_name,
        bp.proposed_use,
        bp.approval_score,
        bp.synthetic_approval,
        fs.default_risk_score,
        ses.displacement_risk_score
      FROM base_planning bp
      LEFT JOIN financial_scores fs ON bp.application_id = fs.application_id
      LEFT JOIN social_economic_scores ses ON bp.application_id = ses.application_id
      WHERE 1=1
    `;
    const params = [];

    if (search) {
      sql += " AND (bp.application_id LIKE ? OR bp.district_name LIKE ?)";
      const term = `%${search}%`;
      params.push(term, term);
    }

    const [rows] = await db.execute(sql, params);
    const proposals = rows.map(rowToProposal);

    let filtered = proposals;
    if (status === "needs_review") {
      filtered = proposals.filter((p) => p.status === "Review");
    } else if (status === "straightforward") {
      filtered = proposals.filter((p) => p.status === "Clear to Proceed");
    }

    const order = sortOrder === "desc" ? -1 : 1;
    const sortKey = sortBy || "referenceId";
    filtered.sort((a, b) => {
      const aVal = a[sortKey] ?? "";
      const bVal = b[sortKey] ?? "";
      if (typeof aVal === "number" && typeof bVal === "number") {
        return (aVal - bVal) * order;
      }
      return String(aVal).localeCompare(String(bVal)) * order;
    });

    const needsReview = proposals.filter((p) => p.status === "Review").length;
    const straightforward = proposals.filter((p) => p.status === "Clear to Proceed").length;

    res.json({
      proposals: filtered,
      counts: {
        total: proposals.length,
        needsReview,
        straightforward,
      },
    });
  } catch (err) {
    console.error("Proposals error:", err);
    res.status(500).json({ error: "Database error" });
  }
});

router.get("/proposals/:id", async (req, res) => {
  try {
    const applicationId = req.params.id.replace(/\+/g, " ");

    const [rows] = await db.execute(
      `
      SELECT 
        bp.application_id,
        bp.submission_date,
        bp.district_name,
        bp.proposed_use,
        bp.approval_score,
        bp.synthetic_approval,
        fs.default_risk_score,
        ses.displacement_risk_score
      FROM base_planning bp
      LEFT JOIN financial_scores fs ON bp.application_id = fs.application_id
      LEFT JOIN social_economic_scores ses ON bp.application_id = ses.application_id
      WHERE bp.application_id = ?
    `,
      [applicationId]
    );

    if (!rows.length) {
      return res.status(404).json({ error: "Proposal not found" });
    }

    const proposal = rowToProposal(rows[0]);

    res.json({
      proposal,
      topRiskDrivers: ["Zoning Non-Compliance", "Traffic Congestion Index", "Water Main Capacity"],
      dataSourcesUsed: ["CITY GIS", "STATSCAN 2026", "TRAFFIC API", "ZONING BYLAW 2022-04"],
    });
  } catch (err) {
    console.error("Proposal detail error:", err);
    res.status(500).json({ error: "Database error" });
  }
});

export default router;
