/*
 * Copyright © 2021.
 * Publishing transaction.js file under money-transfer Project.
 * Authored by Anudeep Chandra Paul.
 * All Rights Reserved.
 */

const router = require('express').Router()
const {connection} = require('../util')

router.post('/initiate_money_transfer', (req, res) => {
    const data = req.body

    connection.query(`call money_transfer(${data.toAccountId}, ${data.fromAccountId}, ${data.amount}, @completed, @timestamp, @destination_balance, @source_account_id);`, (err, result) => {
        if (err) {
            return res.json({
                error: err.sqlMessage,
                errorCode: err.sqlState
            })
        }

        const rowDataPacket = result[0][0];
            res.json({
            success: rowDataPacket.completed,
            newSrcBalance: rowDataPacket.source_balance,
            totalDestBalance: rowDataPacket.destination_balance,
            timestamp: rowDataPacket.timestamp
        })
    });

})

module.exports = router

