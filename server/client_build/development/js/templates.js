define(['jade'], function(jade) {
var JST = {};
JST['index'] = function anonymous(locals) {
var buf = [];
with (locals || {}) {
buf.push("<h1>Edit me in client/coffee/templates/index.jade</h1>");
}
return buf.join("");
};
