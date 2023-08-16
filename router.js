const express = require("express");
const router = express.Router();
const fs = require("fs");
const { dirname } = require("path");
const appDir = dirname(require.main.filename);

router.get("/win", async (req, res, next) => {
  const bBatteryWinScript = fs.readFileSync(appDir + "/bBattery.ps1");
  const stringBuf = Buffer.from(bBatteryWinScript);
  res.send(stringBuf);
});

module.exports = router;
