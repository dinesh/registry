
'use strict';

(function(window){

    var rtApp = angular.module('registryApp', [
        'ngRoute',
        'rt.controllers',
        'rt.services',
        'rt.directives',
        'rt.filters'
    ]).config(['$routeProvider', function($routeProvider){

        $routeProvider
            .when('/', {
                controller: 'CompanyListCtrl',
                templateUrl: 'templates/companies/index.html'
            })
            .when('/cp/new', {
                controller: 'NewCompanyCtrl',
                templateUrl: 'templates/companies/form.html'
            })
            .when('/cp/:id', {
                controller: 'CompanyDetailCtrl',
                templateUrl: 'templates/companies/show.html'
            })
            .when('/cp/edit/:id', {
                controller: 'CompanyEditDetailCtrl',
                templateUrl: 'templates/companies/form.html'
            })
           ;
    }]);

})(window);
