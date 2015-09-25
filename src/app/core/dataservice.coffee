### @ngInject ###
dataservice = ($http, $rootScope) ->
  $rootScope.countries = []
  $rootScope.dimensions = []

  promises = []
  @getData = (locale)->
    locale or= $rootScope.locale
    if !promises[locale]
      promises[locale] = $http.get('/api/'+locale+'/all').then( (response) ->
        $rootScope.countries = response.data.countries
        $rootScope.dimensions = response.data.dimensions
        $rootScope.$broadcast 'data-loaded'
        return response.data
      )

    return promises[locale]

  $rootScope.$on '$translateChangeStart', (event, data) =>
    @getData(data.language).then( (responseData) ->
      $rootScope.locale = data.language
      document.documentElement.setAttribute('lang', data.language)
    )

  return @

dataservice.$inject = [
  '$http'
  '$rootScope'
]


angular.module('app.core').factory 'dataservice', dataservice
