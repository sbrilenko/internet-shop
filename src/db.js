const { Pool } = require('pg');
const pool = new Pool({
  user: 'user',
  host: 'db',
  database: 'database',
  password: 'password',
  port: 5432,
});

async function getProducts() {
  const result = await pool.query('SELECT * FROM products');
  return result.rows;
}

async function createProduct(product) {
  const result = await pool.query('INSERT INTO products (name, price) VALUES ($1, $2) RETURNING *', [product.name, product.price]);
  return result.rows[0];
}

module.exports = { getProducts, createProduct };