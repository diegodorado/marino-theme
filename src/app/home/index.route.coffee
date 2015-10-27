appRun = (routerHelper) ->
  console.log getStates()

  routerHelper.configureStates getStates()

getStates = ->
  [
    #exists only to be redirected
    {
      state: 'app'
      config:
        url: '/'
        views:
          "header":
            templateUrl: 'app/layout/header.html'
            controller: 'Header'
          "sidebar":
            templateUrl: 'app/layout/sidebar.html'
          "content":
            templateUrl: 'app/home/index.html'

    }
    {
      state: 'app.contact'
      config:
        url: '/contact'
        views:
          "content@":
            templateUrl: 'app/contact/contact.html'
            controller: 'Contact'
    }
 ]


angular.module('app.index').run appRun
appRun.$inject = [ 'routerHelper' ]
