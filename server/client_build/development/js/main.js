(function() {
  var VENDOR;

  VENDOR = "vendor";

  requirejs.config({
    paths: {
      'jquery': "" + VENDOR + "/jquery.min",
      'backbone': "" + VENDOR + "/backbone.min",
      'underscore': "" + VENDOR + "/underscore.min",
      'jade': "" + VENDOR + "/jade.min"
    },
    shim: {
      'jquery': {
        exports: '$'
      },
      'backbone': {
        deps: ['underscore', 'jquery'],
        exports: 'Backbone'
      },
      'underscore': {
        exports: '_'
      },
      'jade': {
        exports: 'jade'
      }
    }
  });

  requirejs(['jquery'], function($) {
    return console.log('Edit me in client/coffee/main.coffee.');
  });

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/