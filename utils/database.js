import "dotenv/config";
import mysql from "mysql2/promise";

export default await mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  dateStrings: true, //needed to add this because I was getting NaaN showing up for the dates on the client side
});