# Money transfer API

## Pre-Requisites
- Node is installed on the system. (Mostly `lts` should do fine.)
- `MySql server` is installed (required to run server and carryout transactions)
- `MySql client` is installed (required to carry out data seeding)
- ### Please look into .env file. 
  - #### Enter the hostname (`DB_HOST_NAME`) (usually `localhost`)
  - #### Enter the username (`DB_USER_NAME`) (usually `root`)
  - #### Enter the password (`DB_PASSWORD`)

## Steps to run
- Run `yarn install` or `npm install`
- To seed db, Run `yarn run prepare_db` or `npm run prepare_db`
- Now you're ready to run server with `yarn start` or `npm run start`

##### Written with javascript. ( `typescript` avoided getting rid of unnecessary issues while running different system )
