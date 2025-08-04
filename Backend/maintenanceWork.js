const express = require('express');
const axios = require('axios');
const https = require('https');

const router = express.Router();

// SAP Config
const SAP_BASE_URL = 'http://AZKTLDS5CP.kcloud.com:8000';
const PROFILE_URL = '/sap/opu/odata/SAP/ZMAINTT_PORTAL577_SRV/';
const ENTITY_SET = 'ZWORK_MAINTSet';
const SAP_CREDS = {
  username: 'K901577',
  password: 'Haris@0713',
};

// HTTPS agent to ignore cert issues
const sapAgent = new https.Agent({ rejectUnauthorized: false });

// 📘 GET Work Orders by Plant (Werks)
router.get('/:plantId', async (req, res) => {
  const plantId = req.params.plantId;
  console.log('📥 Fetching work orders for Plant ID:', plantId);

  if (!plantId) {
    return res.status(400).json({ success: false, message: 'Plant ID is required.' });
  }

  try {
    const url = `${SAP_BASE_URL}${PROFILE_URL}${ENTITY_SET}?$filter=Werks eq '${plantId}'&$format=json`;

    const response = await axios.get(url, {
      headers: {
        Authorization:
          'Basic ' + Buffer.from(`${SAP_CREDS.username}:${SAP_CREDS.password}`).toString('base64'),
        Accept: 'application/json',
      },
      httpsAgent: sapAgent,
    });

    const results = response.data?.d?.results;

    if (!results || results.length === 0) {
      return res.status(404).json({ success: false, message: 'No work order data found.' });
    }

    // Transform the response
    const workOrders = results.map(item => ({
      Aufnr: item.Aufnr,
      Qmtxt: item.Qmtxt,
      Autyp: item.Autyp,
      Bukrs: item.Bukrs,
      SworK: item.Swork,
      Werks: item.Werks,
      Ktext: item.Ktext,
      Kostl: item.Kostl,
      Ltxa1: item.Ltxa1,
    }));

    return res.json({ success: true, data: workOrders });
  } catch (error) {
    console.error('❌ SAP Work Order Fetch Error:', {
      status: error.response?.status,
      message: error.message,
      data: error.response?.data,
    });

    return res.status(error.response?.status || 500).json({
      success: false,
      message: 'Failed to fetch work orders',
      error: error.message,
      sapError: error.response?.data,
    });
  }
});

module.exports = router;
