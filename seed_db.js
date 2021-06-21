/*
 * Copyright © 2021.
 * Publishing seed_db.js file under money-transfer Project.
 * Authored by Anudeep Chandra Paul.
 * All Rights Reserved.
 */

require('dotenv').config();

const {connect} = require('./util')

const fs = require("fs");
const cp = require("child_process");

(async function () {
    cp.exec(`mysql --user=${process.env.DB_USER_NAME} --password=${process.env.DB_PASSWORD} < ./migrations/migration.sql`, (err, stdout, stderr) => {
        if (err) {
            console.error(err)
        }

        if (stderr) {
            console.error(stderr);
        }

        if (!err) {
            console.log('[SEEDING_DB] Successfully completed. You can now run the server or directly login to mysql via shell/cmd and validate by running queries.')
            console.log('             USE money_transfer; SELECT * FROM users; SELECT * FROM accounts;')
        }
    });

})();