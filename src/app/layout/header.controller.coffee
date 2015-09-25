### @ngInject ###
Header = ($window, $scope , $translate) ->
  $scope.langOpened = false

  $scope.changeLocale = (locale) ->
    $translate.use(locale)
    $scope.toggleMenu()

  $scope.toggleMenu = (event) ->
    $scope.langOpened = not $scope.langOpened
    # Important part in the implementation
    # Stopping event propagation means window.onclick
    # won't get called when someone clicks
    # on the menu div. Without this, menu will be hidden immediately
    if event?
      event.stopPropagation()

  $window.onclick = () ->
    if $scope.langOpened
      $scope.langOpened = false
      # You should let angular know about the update that you have made,
      # so that it can refresh the UI
      $scope.$apply()

  return

angular.module('app.layout').controller 'Header', Header
Header.$inject = [
  '$window'
  '$scope'
  '$translate'
]
