const express = require("express");
const router = require("./router");
const app = express();
const port = 8003;

app.use(express.static("public"));
app.use("/", router);

app.listen(port, () => {
  console.log(`bBattery run at ${port}`);
});
