var express = require("express");
// var path = require("path");
var bodyParser = require('body-parser');
var io = require('socket.io');
var mysql = require('mysql');

var connection = mysql.createConnection({
    host : 'localhost',
    user : 'root',
    password : 'root',
    database : 'overcast'
});
connection.connect(function (err){
    if (err){
        console.log("DATABASE IS NOT CONNECTED");
    }else{
        console.log("database connection created");
    }
});

var app = express();
var server = app.listen(1337);
console.log("Listening on port 1337");

app.use(bodyParser.urlencoded());
app.use(bodyParser.json());

io = io.listen(server);
require('./server/config/routes.js')(app,io,connection);

// var mysql = require('mysql');
// var connection = mysql.createConnection({
//     host : 'localhost',
//     user : 'root',
//     password : 'root',
//     database : 'overcast'
// });
// connection.connect();

// connection.query('SELECT * FROM users', function (err,rows,fields){
//     if (!err){
//         console.log("the solution is : ", rows);
//     }else{
//         console.log("ERROR : sfsdfds");
//     }
// });
// connection.end();