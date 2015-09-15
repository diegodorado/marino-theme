### @ngInject ###
Contact = ($scope, $stateParams) ->

  $scope.submit = () ->
    #todo: actually send and email
    if $scope.contactForm.$valid
      $scope.close()

  $scope.data =
    name: ''
    email: ''
    query: ''


  return

angular.module('app.overlays').controller 'Contact', Contact
Contact.$inject = [
  '$scope'
  '$stateParams'
]
