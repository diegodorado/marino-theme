### @ngInject ###
configure = ($compileProvider,
  routerHelperProvider
  ) ->

  configureStateHelper = ->

    routerHelperProvider.configure
      docTitle: 'CiberSeguridad: '
      resolveAlways: []

    return

  configureStateHelper()

  themeUrl = (meta.getAttribute("content") for meta in document.getElementsByTagName('meta') when meta.getAttribute("name") is "themeUrl")[0]


configure.$inject = [
    '$compileProvider'
    'routerHelperProvider'
]


core = angular.module('app.core')

core.run [
  '$rootScope'
  '$state'
  '$stateParams'
  ($rootScope, $state, $stateParams) ->
    # It's very handy to add references to $state and $stateParams to the
    # $rootScope so that you can access them from any scope within your
    # applications. For example, <li ng-class="{ active: $state.includes
    # ('contacts.list') }"> will set the <li>  to active whenever
    #'contacts.list' or one of its decendents is active.
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams
    console.log $rootScope.$state
]

config =
  appErrorPrefix: '[GulpPatterns Error] '
  appTitle: 'Gulp Patterns Demo'

core.value 'config', config
core.config configure
