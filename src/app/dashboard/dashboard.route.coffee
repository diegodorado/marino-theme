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
        url: '/graph/zone/:zone/countries/:countries/selected/:last_selected/:offset/dimensions/:expanded_dimensions'
        params:
          zone:
            value: '2'
            squash: false
          countries:
            value: ''
            squash: false
          last_selected:
            value: ''
            squash: false
          offset:
            value: '0'
            squash: false
          expanded_dimensions:
            value: '1-2-3-4-5'
            squash: false
        title: 'Home'
        views:
          "":
            templateUrl: 'app/dashboard/dashboard.html'
            controller: 'Dashboard'
          "aside@graph":
            templateUrl: 'app/dashboard/aside.html'
            controller: 'Aside'
          "eq@graph":
            templateUrl: 'app/dashboard/eq.html'
            controller: 'Eq'
          "map@graph":
            templateUrl: 'app/dashboard/map.html'
            controller: 'MapCtrl'
            controllerAs: 'vm'
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
