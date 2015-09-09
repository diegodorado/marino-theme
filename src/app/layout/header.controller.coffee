### @ngInject ###
Header = ($state, routerHelper, $http, $window, $scope , $translate) ->
  vm = this
  @langOpened = false

  @changeLocale = (locale) ->
    $translate.fallbackLanguage('en')
    $translate.use(locale)
    return

    $http.get('/api/locale/' + locale)
      .success(successCallback)
      .error errorCallback
    return

  successCallback = (arg) ->
    $window.location.reload()
    return

  errorCallback = (arg) ->
    console.log 'error setting locale'
    return



  @toggleMenu = (event) ->
    @langOpened = not @langOpened
    # Important part in the implementation
    # Stopping event propagation means window.onclick
    # won't get called when someone clicks
    # on the menu div. Without this, menu will be hidden immediately
    event.stopPropagation()


  $window.onclick = () ->
    if vm.langOpened
      vm.langOpened = false
      # You should let angular know about the update that you have made,
      # so that it can refresh the UI
      $scope.$apply()

  return

angular.module('app.layout').controller 'Header', Header
Header.$inject = [
  '$state'
  'routerHelper'
  '$http'
  '$window'
  '$scope'
  '$translate'
]
