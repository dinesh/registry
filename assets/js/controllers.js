
'use strict';

(function(window){

    var Company = function(attrs){
        attrs = attrs || {};
        this.name = attrs.name;
        this.email = attrs.email;
        this.phone = attrs.phone;
        return this;
    }

    angular.module('rt.controllers', ['lvl.directives.fileupload'])

        .controller('CompanyListCtrl', function($scope, $location, Company, Companies){
            $scope.companies = Companies.query();

            $scope.createNewCompany = function(){
                $location.url('/cp/new');
            }

            $scope.showCompany = function(cid){
                $location.url('/cp/' + cid);
            }

            $scope.editCompany = function(cid){
                $location.url('/cp/edit/' + cid)
            }

            $scope.deleteCompany = function(cid){
                Company.delete({ 'id': cid });
                $scope.companies = Companies.query();
            }
        })
        .controller('NewCompanyCtrl', ['$scope', 'Companies', '$location', function ($scope, Companies, $location) {

            $scope.createNewCompany = function() {
                Companies.create({
                    'id': $scope.company ? $scope.company.id : null,
                    'company': $scope.company
                }, function(response){
                    $location.path('/');
                }, function(response){
                    $scope.errors = response.data;
                    $location.path('/cp/new');
                });
            }

        }])
        .controller('CompanyEditDetailCtrl', function($scope, $routeParams, Company, Owner, $location) {

                $scope.updateCompany = function () {
                    Company.update($scope.company, {'id': $scope.company.id, 'company': $scope.company }, function(response){
                        $location.path('/');
                    }, function(response){
                        $scope.errors = response.data;
                    })
                };

                $scope.cancel = function () {
                    $location.path('/');
                };

                $scope.showOwnerForm = function(cid){
                    $scope.showOwner = true;
                }

                $scope.company = Company.show({id: $routeParams.id});
                $scope.persist = true
        })

        .controller('CompanyDetailCtrl', function ($scope, $routeParams, Company, Owners, $location, $http, $route) {

                $scope.company = Company.show({id: $routeParams.id});
                $scope.showOwnerForm = false;
                $scope.newOwner = {};
                $scope.owners = Owners.query({ company_id: $routeParams.id })

                $scope.editCompany = function(cid){
                    $location.url('/cp/edit/' + cid);
                }

                $scope.addOwner = function(oid){
                    $scope.showOwnerForm = true
                    if(oid){
                        $scope.owners.forEach(function(ow){
                            if(ow.id == oid)
                                $scope.newOwner = ow;
                        })
                    }
                }

                $scope.$on('fileSelected', function(event, args){
                    $scope.$apply(function(){
                        $scope.files.push(args.file);
                    })
                });

                $scope.done = function(files, data) {
                    if(data.errors){
                        $scope.errors = data.errors;
                    } else {
                        $scope.showOwnerForm = false
                        $scope.owners = Owners.query({ 'company_id': $routeParams.id });
                    }
                };

                $scope.getData = function(files) {
                        $scope.newOwner.company_id = $routeParams.id;
                        return $scope.newOwner;
                };

                $scope.error = function(file, type, msg){
                    alert(type + ": " + msg)
                }

                $scope.uploadError = function(files, type, msg) {
                    console.log("Upload error: " + msg);
                }
        });

})(window);