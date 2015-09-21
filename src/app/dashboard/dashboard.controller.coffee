Dashboard = ($scope, $filter) ->

  $scope.shownCountries = ->
    codes = $scope.$stateParams.countries.split('-')
    selectedCountries = $filter('selectedCountries')($scope.countries,codes)
    offset = $filter('offset')(selectedCountries,$scope.$stateParams.offset)
    $filter('limitTo')(offset,$scope.countriesPerPage())


  $scope.last_selected = ->
    code = $scope.$stateParams.last_selected
    country = (c for c in $scope.countries when c.code is code)[0]
    return country

  $scope.countriesSelected = ->
    $scope.$stateParams.countries.split('-').length

  $scope.countriesPerPage = ->
    if $scope.breakpoint is 'wide' or $scope.breakpoint is 'large'
      return 5
    else
      return 1

  $scope.showGhostCountry = ->
    $scope.countriesSelected() < $scope.countriesPerPage()

  $scope.showPager = ->
    $scope.countriesSelected() > $scope.countriesPerPage()

  return

Dashboard.$inject = [
  '$scope'
  '$filter'
]

angular.module('app.dashboard').controller 'Dashboard', Dashboard
