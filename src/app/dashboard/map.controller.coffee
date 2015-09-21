MapCtrl = ($scope) ->


  loadChart = ->
    $scope.chart.data = [['region', 'color']]
    for c in $scope.countries
      color = 0
      if c.code is $scope.$stateParams.last_selected
        color = 2
      else if $scope.$stateParams.countries.indexOf(c.code) > -1
        color = 1

      $scope.chart.data.push [c.code, color]

    return

  $scope.chartStyle = {}

  $scope.chart =
    type: 'GeoChart'
    data: [['region', 'color'],['ar', 0]]
    options:
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

  $scope.zoomLevel = 2

  $scope.changeZoom = (zoom_level) ->
    $scope.zoomLevel = zoom_level
    if $scope.breakpoint is 'wide'
      if zoom_level is 0
        $scope.chartStyle =
          top: '-220px'
          left: '0px'
        $scope.chart.options.width = 700
        $scope.chart.options.height = 1200
        $scope.chart.options.region = '013'
      if zoom_level is 1
        $scope.chartStyle =
          top: '40px'
          left: '-90px'
        $scope.chart.options.width = 800
        $scope.chart.options.height = 800
        $scope.chart.options.region = '029'
      if zoom_level is 2
        $scope.chartStyle =
          top: '-680px'
          left: '-860px'
        $scope.chart.options.width = 2200
        $scope.chart.options.height = 1500
        #$scope.chart.options.region = '005'
        $scope.chart.options.region = '019'

    if $scope.breakpoint is 'large'
      if zoom_level is 0
        $scope.chartStyle =
          top: '-220px'
          left: '40px'
        $scope.chart.options.width = 500
        $scope.chart.options.height = 1200
        $scope.chart.options.region = '013'
      if zoom_level is 1
        $scope.chartStyle =
          top: '40px'
          left: '-120px'
        $scope.chart.options.width = 700
        $scope.chart.options.height = 700
        $scope.chart.options.region = '029'
      if zoom_level is 2
        $scope.chartStyle =
          top: '-680px'
          left: '-940px'
        $scope.chart.options.width = 2200
        $scope.chart.options.height = 1500
        $scope.chart.options.region = '019'



  $scope.chartOnReady = (chartWrapper) ->
    $scope.chartWrapper = chartWrapper

  $scope.chartOnSelect = (selectedItem) ->
    dt = $scope.chartWrapper.getDataTable()
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
    loadChart()


  $scope.changeZoom($scope.zoomLevel)
  loadChart()

  $scope.$on 'country-toggled', (event, args) ->
    loadChart()

  $scope.$on 'data-loaded', (event, args) ->
    loadChart()

  $scope.$on 'breakpoint:change', (event, args) ->
    $scope.changeZoom($scope.zoomLevel)

  return

MapCtrl.$inject = [
  '$scope'
]

angular.module('app.dashboard').controller 'MapCtrl', MapCtrl
