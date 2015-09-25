Footer = ($scope, $anchorScroll) ->

  $scope.year = (new Date()).getFullYear()

  $scope.goToTop = ($event) ->
    $event.stopPropagation()
    $anchorScroll()

  return

angular.module('app.layout').controller 'Footer', Footer
Footer.$inject = [
  '$scope'
  '$anchorScroll'
]
