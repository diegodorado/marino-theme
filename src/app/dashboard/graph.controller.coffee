Graph = ($scope, $rootScope) ->

  $scope.next = ->
    if $scope.$stateParams.offset < $scope.countriesSelected() - $scope.countriesPerPage()
      $scope.$stateParams.offset++
      $scope.updateUrl()

  $scope.prev = ->
    if $scope.$stateParams.offset > 0
      $scope.$stateParams.offset--
      $scope.updateUrl()

  $scope.toggleCountriesOff = ->
    $scope.$stateParams.last_selected = ''
    $scope.$stateParams.countries = ''
    $scope.countrySelectOpened = false
    $scope.updateUrl()
    $rootScope.$broadcast 'country-toggled'

  $scope.toggleCountry = (code, $event) ->
    $event?.stopPropagation()

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
  $scope.toggleCountrySelect = ($event) ->
    $scope.countrySelectOpened = not $scope.countrySelectOpened
    return

  $scope.toggleDimension = (dimension) ->
    expanded = []
    if $scope.$stateParams.expanded_dimensions isnt 'none'
      expanded = $scope.$stateParams.expanded_dimensions.split('-')


    index = expanded.indexOf(dimension.id.toString())

    if index is -1
      expanded.push dimension.id.toString()
    else
      expanded.splice index, 1

    if expanded.length is 0
      $scope.$stateParams.expanded_dimensions = 'none'
    else
      $scope.$stateParams.expanded_dimensions = expanded.join('-')

    $scope.updateUrl()

  $scope.expandedDimension = (dimension) ->
    if $scope.$stateParams.expanded_dimensions is 'none'
      return false

    $scope.$stateParams.expanded_dimensions.indexOf(dimension.id) > -1



  $scope.handleDrop = (codeA, codeB) ->
    console.log codeA, codeB
    codeA = codeA.replace('country-','')
    codeB = codeB.replace('country-','')
    codes = $scope.$stateParams.countries.split('-')
    codes[codes.indexOf(codeA)] = codeB
    codes[codes.indexOf(codeB)] = codeA
    $scope.$stateParams.countries = codes.join('-')
    $scope.updateUrl()


  return

Graph.$inject = [
  '$scope'
  '$rootScope'
]

angular.module('app.dashboard').controller 'Graph', Graph
