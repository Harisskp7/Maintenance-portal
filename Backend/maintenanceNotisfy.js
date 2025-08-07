const express = require('express');
const axios = require('axios');
const https = require('https');

const router = express.Router();

// SAP Configuration
const SAP_BASE_URL = 'http://AZKTLDS5CP.kcloud.com:8000';
const PROFILE_URL = '/sap/opu/odata/SAP/ZMAINTT_PORTAL577_SRV/';
const ENTITY_SET = 'ZNOTISFY_MAINTSet'; // Your maintenance entity set
const SAP_CREDS = {
  username: 'K901577',
  password: 'Harish@0701',
};

// HTTPS agent to ignore certificate issues
const sapAgent = new https.Agent({ rejectUnauthorized: false });

// 📘 GET Maintenance Notification data by Plant (Iwerk)
router.get('/:plantId', async (req, res) => {
  const plantId = req.params.plantId;
  console.log('📥 Fetching maintenance notifications for Plant ID:', plantId);

  if (!plantId) {
    return res.status(400).json({ success: false, message: 'Plant ID is required.' });
  }

  try {
    const url = `${SAP_BASE_URL}${PROFILE_URL}${ENTITY_SET}?$filter=Iwerk eq '${plantId}'&$format=json`;

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
      return res.status(404).json({ success: false, message: 'No maintenance notifications found.' });
    }

    // Transform the response
    const notifications = results.map(item => ({
      Qmnum: item.Qmnum,
      Iwerk: item.Iwerk,
      IloAn: item.IloAn,
      Equnr: item.Equnr,
      Ingrp: item.Ingrp,
      Ausvn: item.Ausvn,
      Qmart: item.Qmart,
      Auszt: item.Auszt,
      Artyp: item.Artyp,
      Qmtxt: item.Qmtxt,
      PrioK: item.PrioK,
      Arbplwerk: item.Arbplwerk,
      Status: item.Status,
    }));

    return res.json({ success: true, data: notifications });
  } catch (error) {
    console.error('❌ SAP Maintenance Notification Fetch Error:', {
      status: error.response?.status,
      message: error.message,
      data: error.response?.data,
    });

    return res.status(error.response?.status || 500).json({
      success: false,
      message: 'Failed to fetch maintenance notifications',
      error: error.message,
      sapError: error.response?.data,
    });
  }
});

module.exports = router;
