'use strict';

(function(window){

    angular.module('rt.services', ['ngResource'])
        .factory('Company', function($resource){
            return $resource('/companies/:id', {}, {
                show: { method: 'GET' },
                update: { method: 'PUT', params: {id: '@id'} },
                delete: { method: 'DELETE', params: {id: '@id'} }
            })
        })
        .factory('Companies', function ($resource) {
            return $resource('/companies', {}, {
                query: { method: 'GET', isArray: true },
                create: { method: 'POST' }
            })
        })
        .factory('Owner', function($resource){
            return $resource('/owner/:id', {}, {
                show: { method: 'GET' },
                update: { method: 'PUT', params: {id: '@id'}, enctype:'multipart/form-data' },
                delete: { method: 'DELETE', params: {id: '@id'} }
            })
        })
        .factory('Owners', function ($resource) {
            return $resource('/owners', {}, {
                query: { method: 'GET', isArray: true },
                create: { method: 'POST', enctype:'multipart/form-data' }
            })
        })

})(window);