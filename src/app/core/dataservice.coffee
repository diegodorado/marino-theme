### @ngInject ###
dataservice = ($http, $rootScope) ->
  $rootScope.countries = []
  $rootScope.dimensions = []

  promises = []
  @getData = (locale)->
    if !promises[locale]
      promises[locale] = $http.get('/api/'+locale+'/all').then( (response) ->
        response.data
      )

    return promises[locale]

  @prepareData = ->
    locale = $rootScope.locale
    unless promises[locale]?.$$state?.status is 1
      @getData(locale).then( (data) ->
        $rootScope.countries = data.countries
        $rootScope.dimensions = data.dimensions
        $rootScope.$broadcast 'data-loaded'
      )

  $rootScope.$on '$translateChangeStart', (event, eventData) =>
    locale = eventData.language
    if $rootScope.$stateParams.locale
      $rootScope.$stateParams.locale = locale
      #$rootScope.updateUrl()
      $rootScope.$state.go($rootScope.$state.current, $rootScope.$stateParams, {notify: true})

    #if $scope.$stateParams.locale = locale

    @getData(locale).then( (data) ->
      console.log eventData, data
      $rootScope.locale = locale
      document.documentElement.setAttribute('lang', locale)
      $rootScope.countries = data.countries
      $rootScope.dimensions = data.dimensions
      $rootScope.$broadcast 'data-loaded'
    )

  return @

dataservice.$inject = [
  '$http'
  '$rootScope'
]


angular.module('app.core').factory 'dataservice', dataservice
