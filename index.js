/*
 * Copyright © 2021.
 * Publishing index.js file under money-transfer Project.
 * Authored by Anudeep Chandra Paul.
 * All Rights Reserved.
 */

require('dotenv').config();

const express = require('express')
const bodyParser = require("body-parser");
const cors = require("cors");
const helmet = require("helmet");
const PORT = 5000;
const {connect} = require("./util");
const initiateRoutes = require('./routes')

const app = express()

app.use(bodyParser.urlencoded({ extended: false }))
app.use(express.json())
app.use(cors({
    origin: '*'
}))
app.use(helmet())

initiateRoutes(app);

connect().then(r => app.listen(PORT, () => {
    console.log(`Server started on ${PORT}`)
    console.log('API exposed on /transaction/initiate_money_transfer')
}))



