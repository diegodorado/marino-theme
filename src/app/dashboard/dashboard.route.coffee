getStates = ->
  [
    {
      state: 'dashboard'
      config:
        url: '/'
        templateUrl: 'app/dashboard/dashboard.html'
        controller: 'Dashboard'
        controllerAs: 'vm'
        title: 'Home'
        settings:
          nav: 1
          content: '<i class="fa fa-dashboard"></i> Dashboard'
    }

    {
      state: 'about'
      config:
        url: '/:locale/about'
        templateUrl: ($stateParams) ->
          return '/about-' + $stateParams.locale + '.html'
        title: 'about'
    }

    {
      state: 'contributors'
      config:
        url: '/:locale/contributors'
        templateUrl: ($stateParams) ->
          return '/contributors-' + $stateParams.locale + '.html'
        title: 'contributors'
    }

    {
      state: 'institutional-information'
      config:
        url: '/:locale/institutional-information'
        templateUrl: ($stateParams) ->
          return '/institutional-information-' + $stateParams.locale + '.html'
        title: 'institutional-information'
    }


  ]

### @ngInject ###
appRun = (routerHelper) ->
  routerHelper.configureStates getStates(), '/'
appRun.$inject = [ 'routerHelper' ]

angular.module('app.dashboard').run appRun
