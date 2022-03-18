const express = require("express");
const app = express();
require('dotenv').config();

app.use(express.urlencoded({extended: false}));
app.use(express.json());
app.use(require('./routes/routes.js'))

const PORT = process.env.PORT || 5555;

app.listen(PORT, () => {
    console.log("Server on port: " + PORT);
});