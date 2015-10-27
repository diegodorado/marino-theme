### @ngInject ###
Header = ($scope ) ->
  $scope.langOpened = false


  return

angular.module('app.layout').controller 'Header', Header
Header.$inject = [
  '$scope'
]
