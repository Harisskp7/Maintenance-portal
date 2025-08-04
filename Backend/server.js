// server.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');
const xml2js = require('xml2js');
const https = require('https');

// Import route files
const maintLoginRoute = require('./maintenanceLogin');
const maintNotify = require('./maintenanceNotisfy');
const maintWork = require('./maintenanceWork');
const maintPlant = require('./maintenancePlant');
// const vendorGrRoute = require('./vendorGrRoute');
// const vendorInvoiceRoute = require('./vendorInvoiceRoute');
// const vendorMemoRoute = require('./vendorMemoRoute');
// const vendorPayRoute = require('./vendorPayRoute');
// const vendorFormRoute = require('./vendorFormRoute');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(bodyParser.json());

// Test endpoint
app.get('/api/test', (req, res) => {
  res.json({ success: true, message: 'Backend is working!' });
});

// Route mounting - Use your real backend endpoints
app.use('/api/maint/login', maintLoginRoute);
app.use('/api/maint/notisfy', maintNotify);
app.use('/api/maint/work', maintWork);
app.use('/api/maint/plant', maintPlant);
// app.use('/api/vendor/gr', vendorGrRoute);
// app.use('/api/vendor/inv', vendorInvoiceRoute);
// app.use('/api/vendor/memo', vendorMemoRoute);
// app.use('/api/vendor/pay', vendorPayRoute);
// app.use('/api/vendor/form', vendorFormRoute);

// Start server
app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});
