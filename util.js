/*
 * Copyright © 2021.
 * Publishing util.js file under money-transfer Project.
 * Authored by Anudeep Chandra Paul.
 * All Rights Reserved.
 */

const mysql = require('mysql')

let connection = mysql.createConnection({
    host: process.env.DB_HOST_NAME,
    user: process.env.DB_USER_NAME,
    password: process.env.DB_PASSWORD,
    database: 'money_transfer',
    multipleStatements: true
});;

const connect = () => new Promise((res, rej) => {
    connection.connect((err, results) => {
        if (err) {
            return rej(err)
        }
        connection = connection;
        return res(connection)
    });
})


module.exports = {
    connection, connect
}