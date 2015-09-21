Aside = ($scope, $rootScope) ->

  $scope.last_selected = ->
    code = $scope.$stateParams.last_selected
    country = (c for c in $scope.countries when c.code is code)[0]
    return country

  $scope.toggleCountriesOff = ->
    $scope.$stateParams.last_selected = ''
    $scope.$stateParams.countries = ''
    $scope.countrySelectOpened = false
    $scope.updateUrl()
    $rootScope.$broadcast 'country-toggled'

  $scope.toggleCountry = (code) ->
    codes = []
    if $scope.$stateParams.countries.length > 0
      codes = $scope.$stateParams.countries.split('-')
    $scope.countrySelectOpened = false

    index = codes.indexOf(code)
    if index is -1
      $scope.$stateParams.last_selected = code
      codes.push code
    else
      codes.splice index, 1
      [..., last] = codes
      $scope.$stateParams.last_selected = if last? then last else ''

    $scope.$stateParams.countries = codes.join('-')
    $scope.updateUrl()
    $rootScope.$broadcast 'country-toggled'


  $scope.countrySelectOpened = false
  $scope.toggleCountrySelect = ->
    $scope.countrySelectOpened = not $scope.countrySelectOpened
    return


  return

Aside.$inject = [
  '$scope'
  '$rootScope'
]

angular.module('app.dashboard').controller 'Aside', Aside
