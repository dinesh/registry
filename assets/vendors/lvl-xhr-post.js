var module;

try {
    module = angular.module('lvl.services');
} catch (e) {
    module  = angular.module('lvl.services', []);
}

module.factory('uuid', function() {
    var svc = {
        new: function() {
            function _p8(s) {
                var p = (Math.random().toString(16)+"000000000").substr(2,8);
                return s ? "-" + p.substr(0,4) + "-" + p.substr(4,4) : p ;
            }
            return _p8() + _p8(true) + _p8(true) + _p8();
        },

        empty: function() {
          return '00000000-0000-0000-0000-000000000000';
        }
    };

    return svc;
});


module.factory('fileUploader', ['$rootScope', '$q', function($rootScope, $q) {
    var svc = {
        post: function(files, data, progressCb) {

            return {
                to: function(uploadUrl)
                {
                    var deferred = $q.defer()
                    if (!files || !files.length) {
                        deferred.reject("No files to upload");
                        return;
                    }

                    var xhr = new XMLHttpRequest();
                    xhr.upload.onprogress = function(e) {
                        $rootScope.$apply (function() {
                            var percentCompleted;
                            if (e.lengthComputable) {
                                percentCompleted = Math.round(e.loaded / e.total * 100);
                                if (progressCb) {
                                    progressCb(percentCompleted);
                                } else if (deferred.notify) {
                                    deferred.notify(percentCompleted);
                                }
                            }
                        });
                    };

                    xhr.onload = function(e) {
                        $rootScope.$apply (function() {
                            var ret = {
                                files: files,
                                data: angular.fromJson(xhr.responseText)
                            };
                            deferred.resolve(ret);
                        })
                    };

                    xhr.upload.onerror = function(e) {
                        var msg = xhr.responseText ? xhr.responseText : "An unknown error occurred posting to '" + uploadUrl + "'";
                        $rootScope.$apply (function() {
                            deferred.reject(msg);
                        });
                    }

                    var formData = new FormData();

                    if (data) {
                        Object.keys(data).forEach(function(key) {
                            formData.append(key, data[key]);
                        });
                    }

                    for (var idx = 0; idx < files.length; idx++) {
                        formData.append(files[idx].name, files[idx]);
                    }

                    xhr.open("POST", uploadUrl);
                    xhr.send(formData);

                    return deferred.promise;
                }
            };
        }
    };

    return svc;
}]);