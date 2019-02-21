//
//  Exercise 9: Scripting languages
//  Part 1: Server side scripting
//  Programming Languages 2
//  Michael Beyer
//

//
// ! npm install express and pug !
//

var path       = require('path');
var express    = require('express');
var bodyParser = require("body-parser");
var game       = require('./game');

var app = express();

// view engine setup
app.set('views', 'views');
app.set('view engine', 'pug');
app.locals.pretty = true;       // generate pretty html

var PORT = 3000;

app.use(bodyParser.urlencoded( { extended: true } ) );

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// GET requests
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
app.get('/', function( req, res )
{
  let gameValues = game.getCurrent();
  gameValues.state = '';
  res.render( 'index', gameValues );
});

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// POST requests
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
app.post('/pl2/longestPal', function( req, res )
{
  let state = '';
  let gameValues = game.getCurrent();
  gameValues.state = state;

  if( req.body.hasOwnProperty('answer') )
  {
    state = game.checkAnswer(req.body['answer']);
    gameValues.state = state;
  }

  res.render('index', gameValues );
});

app.listen(PORT);
console.log( 'Listening on localhost, port ' + PORT );
