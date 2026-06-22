const express = require('express');
const app = express();
const AWS = require('aws-sdk');
const { CognitoIdentityServiceProvider } = require('aws-sdk');
const s3 = new AWS.S3({ region: process.env.AWS_REGION });
const cognito = new CognitoIdentityServiceProvider({ region: process.env.AWS_REGION });
const db = require('./db');

app.use(express.json());

app.get('/products', async (req, res) => {
  const products = await db.getProducts();
  res.json(products);
});

app.post('/products', async (req, res) => {
  const product = req.body;
  const result = await db.createProduct(product);
  res.json(result);
});

app.post('/upload', async (req, res) => {
  const file = req.body.file;
  const params = {
    Bucket: 'product-photos',
    Key: file.originalname,
    Body: file.buffer,
  };
  s3.upload(params, (err, data) => {
    if (err) {
      console.log(err);
    } else {
      res.json({ message: 'File uploaded successfully' });
    }
  });
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});