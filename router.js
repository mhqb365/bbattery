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

router.get("/mac", async (req, res, next) => {
  const bBatteryMacScript = `a=$(ioreg -l -w0 | grep Capacity) && echo $a > a.xml`;
  res.send(bBatteryMacScript);
});

module.exports = router;
