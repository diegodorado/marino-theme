### @ngInject ###
appRun = (routerHelper) ->
    routerHelper.configureStates getStates()

getStates = ->
    [ {
        state: 'map'
        config:
            url: '/about-map'
            templateUrl: 'app/map/map.html'
            title: 'Map'
    } ]

angular.module('app.map').run appRun
appRun.$inject = [ 'routerHelper' ]
