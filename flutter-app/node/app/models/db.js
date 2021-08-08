const mysql = require("mysql");
//const dbConfig = require("../config/db.config.js");

// Create a connection to the database
const connection = mysql.createConnection({
  host:'127.0.0.1',
    port: '3306',
    user: 'root',
    password: '',
    database: 'weadvert',
});

// open the MySQL connection
connection.connect(error => {
  if (error) throw error;
  console.log("Successfully connected to the database.");
});

module.exports = connection;