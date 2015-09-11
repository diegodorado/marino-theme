### @ngInject ###
CountryDetails = ($scope, $stateParams) ->

  @init = () ->
    c = (c for c in $scope.countries when c.code is $stateParams.code)[0]
    $scope.country = c

  $scope.$on 'data-loaded', (event, args) =>
    @init()

  @init()

  return

angular.module('app.overlays').controller 'CountryDetails', CountryDetails
CountryDetails.$inject = [
  '$scope'
  '$stateParams'
]
