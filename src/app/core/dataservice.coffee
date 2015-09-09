### @ngInject ###
dataservice = ($http) ->

  @getData = ->
    return $http.get('/api/all')

  return @

dataservice.$inject = [
  '$http'
]

angular.module('app.core').factory 'dataservice', dataservice
