getStates = ->
  [
    #exists only to be redirected
    {
      state: 'root'
      config:
        url: '/'
    }

    {
      state: 'graph'
      config:
        url: '/graph/:countries/:last_selected/:offset/:colapsed_dimensions'
        params:
          countries:
            value: ''
            squash: false
          last_selected:
            value: ''
            squash: false
          offset:
            value: '0'
            squash: false
          colapsed_dimensions:
            value: ''
            squash: false
        title: 'Home'
        views:
          "":
            templateUrl: 'app/dashboard/dashboard.html'
            controller: 'Dashboard'
            controllerAs: 'vm'
          "aside@graph":
            templateUrl: 'app/dashboard/aside.html'
            controller: 'Aside'
          "graph@graph":
            templateUrl: 'app/dashboard/graph.html'
            controller: 'Graph'
          "stats@graph":
            templateUrl: 'app/dashboard/stats.html'
            controller: 'Stats'
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
