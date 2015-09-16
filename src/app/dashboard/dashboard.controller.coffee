Dashboard = (logger, $scope, $window) ->

  vm = this

  @loadChart = ->
    @chart.data = [['region', 'color']]
    for c in $scope.countries
      color = 0
      if c.code is $scope.$stateParams.last_selected
        color = 2
      else if $scope.$stateParams.countries.indexOf(c.code) > -1
        color = 1

      @chart.data.push [c.code, color]

    return

  @chartStyle =
    height: '1500px'
    top: '-684px'
    left: '-860px'

  @chart =
    type: 'GeoChart'
    data: [['region', 'color'],['ar', 0]]
    options:
      width: 2200
      colorAxis:
        values: [0,1,2]
        colors: ['#f0f0f0','#ddd','#cacaca']
      backgroundColor: 'transparent'
      datalessRegionColor: 'transparent'
      defaultColor: '#f5f5f5'
      displayMode: 'regions'
      region: '019'
      legend: 'none'
      tooltip:
        trigger: 'none'


  @getMaturityLevel= (country_id,indicator_id)->
    c = (c for c in $scope.countries when c.id is country_id)[0]
    return c.maturity_levels[indicator_id]

  @getEqLevel= (country, indicator_id)->
    if country? then country.maturity_levels[indicator_id] else 5

  @chartOnReady = (chartWrapper) =>
    @chartWrapper = chartWrapper

  @chartOnSelect = (selectedItem) =>
    dt = @chartWrapper.getDataTable()
    code = $scope.$stateParams.last_selected
    if selectedItem?
      code = dt.getValue(selectedItem.row,0)

    codes = []
    if $scope.$stateParams.countries.length > 0
      codes = $scope.$stateParams.countries.split('-')

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
    @loadChart()

  @loadChart()

  $scope.$on 'country-toggled', (event, args) =>
    @loadChart()

  $scope.$on 'data-loaded', (event, args) =>
    @loadChart()




  return

Dashboard.$inject = [
  'logger'
  '$scope'
  '$window'
]

angular.module('app.dashboard').controller 'Dashboard', Dashboard
