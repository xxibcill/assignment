// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var App = require("./App.bs.js");
var React = require("react");
var ReactDom = require("react-dom");

require('./index.css')
;

var root = document.querySelector("#root");

if (!(root == null)) {
  ReactDom.render(React.createElement(App.make, {}), root);
}

/*  Not a pure module */
