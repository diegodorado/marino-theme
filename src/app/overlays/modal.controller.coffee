### @ngInject ###
Modal = ($scope, $window, $document) ->

  @close = () ->
    $window.history.back()


  $window.onclick = () =>
    console.log 'close me!'
    @close()


  keyupHandler = (event) =>
    console.log event.keyCode
    if event.keyCode is 27
      @close()


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
