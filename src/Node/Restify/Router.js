"use strict";

// module Node.Restify.Router

var Router = require('restify-router').Router;

exports.mkRouter = function() {
    return new Router();
};

exports.applyRoutes = function(router, server, opts) {
    return function() {
        router.applyRoutes(server, opts);
    };
};

exports.applyRoutes1 = function(router, server) {
    return function() {
        router.applyRoutes(server);
    };
};

exports._http = function(router, method, opts, handler) {
    return function() {
        router[method](opts, function(req, res, next) {
            return handler(req)(res)(next)();
        });
    };
};
