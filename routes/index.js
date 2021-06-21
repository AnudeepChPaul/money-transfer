/*
 * Copyright © 2021.
 * Publishing index.js file under money-transfer Project.
 * Authored by Anudeep Chandra Paul.
 * All Rights Reserved.
 */

const transactionRouter = require('./transaction')

module.exports = app => {
    app.use('/transaction', transactionRouter)
}