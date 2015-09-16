Graph = ($scope, $rootScope) ->

  $scope.next = ->
    if $scope.$stateParams.offset < $scope.$stateParams.countries.split('-').length
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
    colapsed = $scope.$stateParams.colapsed_dimensions.split('-')
    index = colapsed.indexOf(dimension.id.toString())
    if index is -1
      colapsed.push dimension.id.toString()
    else
      colapsed.splice index, 1

    $scope.$stateParams.colapsed_dimensions = colapsed.join('-')
    $scope.updateUrl()

  $scope.colapsedDimensions = (dimension) ->
    $scope.$stateParams.colapsed_dimensions.indexOf(dimension.id) > -1


  $scope.handleDrop = (codeA, codeB) ->
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
