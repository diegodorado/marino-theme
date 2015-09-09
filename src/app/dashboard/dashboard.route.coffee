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
        params: { locale: {} },
        url: '/about'
        templateUrl: ($stateParams) ->
          return '/about-' + $stateParams.locale + '.html'
        title: 'about'
    }

    {
      state: 'countributors'
      config:
        params: { locale: {} },
        url: '/countributors'
        templateUrl: ($stateParams) ->
          return '/countributors-' + $stateParams.locale + '.html'
        title: 'countributors'
    }

    {
      state: 'institutional-information'
      config:
        params: { locale: {} },
        url: '/institutional-information'
        templateUrl: ($stateParams) ->
          return '/institutional-information-' + $stateParams.locale + '.html'
        title: 'institutional-information'
    }

    {
      state: 'contact'
      config:
        params: { locale: {} },
        url: '/contact'
        templateUrl: ($stateParams) ->
          return '/contact-' + $stateParams.locale + '.html'
        title: 'contact'
    }

  ]

### @ngInject ###
appRun = (routerHelper) ->
  routerHelper.configureStates getStates(), '/'
appRun.$inject = [ 'routerHelper' ]

angular.module('app.dashboard').run appRun
