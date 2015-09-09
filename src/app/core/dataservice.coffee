### @ngInject ###
dataservice = ($http) ->

  @getData = (locale)->
    return $http.get('/api/'+locale+'/all')

  return @

dataservice.$inject = [
  '$http'
]

angular.module('app.core').factory 'dataservice', dataservice
