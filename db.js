// loads env vars for databse connection
import 'dotenv/config'
import mysql from 'mysql2/promise'

// creates a connection pool to mysql - reuses connnections for better perfomance
const connection = mysql.createPool({
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE || process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
})

export default connection