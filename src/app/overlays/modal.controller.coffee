### @ngInject ###
Modal = ($scope, $window, $document) ->

  $scope.close = () ->
    $window.history.back()


  $window.onclick = (event) ->
    if event.target.className is 'modal-holder'
      $scope.close()


  keyupHandler = (event) ->
    if event.keyCode is 27
      $scope.close()


  $document.on('keyup', keyupHandler)

  $scope.$on('$destroy',  () ->
    $document.off 'keyup', keyupHandler
  )

  return

angular.module('app.overlays').controller 'Modal', Modal
Modal.$inject = [
  '$scope'
  '$window'
  '$document'
]
