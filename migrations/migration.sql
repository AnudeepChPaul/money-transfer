/*
 * Copyright © 2021.
 * Publishing migration.sql file under money-transfer Project.
 * Authored by Anudeep Chandra Paul.
 * All Rights Reserved.
 */

/*
 * Copyright © 2021.
 * Publishing migration.sql file under money-transfer Project.
 * Authored by Anudeep Chandra Paul.
 * All Rights Reserved.
 */


CREATE DATABASE IF NOT EXISTS money_transfer;

USE money_transfer;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS accounts;

CREATE table accounts
(
    account_id      VARCHAR(25) UNICODE NOT NULL,
    account_status  INT                 NOT NULL DEFAULT 1,
    account_balance INT                 NOT NULL DEFAULT 2000,
    last_updated    TIMESTAMP                    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    primary key (account_id)
);

CREATE table users
(
    user_name  VARCHAR(50) UNICODE NOT NULL,
    user_id    VARCHAR(25) UNICODE NOT NULL,
    account_id VARCHAR(25) UNICODE NOT NULL,
    primary key (user_name, user_id),
    foreign key (account_id) references accounts (account_id)
        on delete CASCADE
);

DROP PROCEDURE IF EXISTS money_transfer;

DELIMITER @@;
CREATE PROCEDURE money_transfer(IN destination_account_id VARCHAR(25), IN source_account_id VARCHAR(25), IN amount int,
                                OUT completed int, OUT timestamp TIMESTAMP, OUT destination_balance int,
                                OUT source_balance int)
BEGIN
    DECLARE `min_amount` CONDITION FOR SQLSTATE '45001';
    DECLARE `min_balance` CONDITION FOR SQLSTATE '45002';
    DECLARE `src_update_exception` CONDITION FOR SQLSTATE '45003';
    DECLARE `dest_update_exception` CONDITION FOR SQLSTATE '45004';
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    SET @MIN_AMOUNT_TO_BE_SEND = 500;
    SET @MIN_ACCOUNT_BALANCE_TOBE_KEPT_ALWAYS = 1000;

    SET autocommit = 0;
    SET @error_msg = '';
    SET `completed` = 0;
    SET source_balance = NULL;
    SET destination_balance = NULL;

    SELECT account_balance into source_balance from accounts where account_id = source_account_id;
    SELECT account_balance into destination_balance from accounts where account_id = destination_account_id;

    IF source_balance IS NULL THEN
        SIGNAL src_update_exception
            SET MESSAGE_TEXT = 'UNABLE_TO_FIND_SOURCE_ACCOUNT', MYSQL_ERRNO = 1003;
    END IF;

    IF destination_balance IS NULL THEN
        SIGNAL dest_update_exception
            SET MESSAGE_TEXT = 'UNABLE_TO_FIND_DESTINATION_ACCOUNT', MYSQL_ERRNO = 1004;
    END IF;

    -- ASSUMING MIN AMOUNT TO BE SENT IS 500
    IF (amount < @MIN_AMOUNT_TO_BE_SEND) THEN
        SIGNAL min_amount
            SET MESSAGE_TEXT = 'E_MIN_TRANSFERRING_AMOUNT_SHOULD_BE_500', MYSQL_ERRNO = 1001;

    ELSEIF (source_balance - amount) >= @MIN_ACCOUNT_BALANCE_TOBE_KEPT_ALWAYS THEN -- ACCOUNT BALANCE CANNOT GO BELOW 1000/RS
        START TRANSACTION;
            UPDATE accounts
            SET account_balance = account_balance + amount
            WHERE account_id = destination_account_id;

            UPDATE accounts
            SET account_balance = account_balance - amount
            WHERE account_id = source_account_id;

            SET completed = 1;
            SET autocommit = 1;
        COMMIT;
    ELSE
        SIGNAL min_balance
            SET MESSAGE_TEXT= 'E_MIN_BALANCE_SHOULD_BE_1000', MYSQL_ERRNO = 1002;
    END IF;

    SELECT (SELECT completed)                                                               as 'completed',
           (SELECT CURRENT_TIMESTAMP)                                                       as 'timestamp',
           (SELECT account_balance from accounts WHERE account_id = destination_account_id) as 'destination_balance',
           (SELECT account_balance from accounts WHERE account_id = source_account_id)      as 'source_balance';
END @@;


-- SEED DATA CREATION STARTS FROM HERE

-- Dummy user accounts
insert into accounts (account_id, account_status, account_balance)
values ('1111111111', 1, 50000);
insert into accounts (account_id, account_status, account_balance)
values ('2222222222', 1, 50000);
insert into accounts (account_id, account_status, account_balance)
values ('3333333333', 1, 20000);
insert into accounts (account_id, account_status, account_balance)
values ('4444444444', 1, 100000);
insert into accounts (account_id, account_status, account_balance)
values ('5555555555', 1, 250000);
insert into accounts (account_id, account_status, account_balance)
values ('6666666666', 1, 500000);
insert into accounts (account_id, account_status, account_balance)
values ('7777777777', 1, 15000);
insert into accounts (account_id, account_status, account_balance)
values ('8888888888', 1, 7000);
insert into accounts (account_id, account_status, account_balance)
values ('9999999999', 1, 9000);
insert into accounts (account_id, account_status, account_balance)
values ('0000000000', 1, 1000);

-- Dummy user profiles
insert into users (user_name, user_id, account_id)
values ('Person A',
        '1111111111',
        '1111111111');
insert into users (user_name, user_id, account_id)
values ('Person B',
        '2222222222',
        '2222222222');
insert into users (user_name, user_id, account_id)
values ('Person C',
        '3333333333',
        '3333333333');
insert into users (user_name, user_id, account_id)
values ('Person D',
        '4444444444',
        '4444444444');
insert into users (user_name, user_id, account_id)
values ('Person E',
        '5555555555',
        '5555555555');
insert into users (user_name, user_id, account_id)
values ('Person F',
        '6666666666',
        '6666666666');
insert into users (user_name, user_id, account_id)
values ('Person G',
        '7777777777',
        '7777777777');
insert into users (user_name, user_id, account_id)
values ('Person H',
        '8888888888',
        '8888888888');
insert into users (user_name, user_id, account_id)
values ('Person I',
        '9999999999',
        '9999999999');
insert into users (user_name, user_id, account_id)
values ('Person J',
        '0000000000',
        '0000000000');
