Dashboard = (logger, $scope, $window) ->

  vm = this

  @loadChart = ->
    @chart.data = [['region', 'color']]
    for c in $scope.countries
      color = 0
      if c is @last_selected_country
        color = 2
      else if c.code in @selected_countries_codes
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
    if selectedItem?
      code = dt.getValue(selectedItem.row,0)
      country = (c for c in $scope.countries when c.code is code)[0]
      @toggleCountry country
    else
      @toggleCountry @last_selected_country



  @deselectAllCountries = (event) ->
    event.stopPropagation()
    @selected_countries = []
    @last_selected_country = null
    @loadChart()

  @toggleCountryHeader = (country, event) ->
    @toggleCountryHeaderSelect(event)
    @toggleCountry(country, event)

  @toggleCountry = (country, event) ->
    @countrySelectOpened = false


    if event?
      event.stopPropagation()

    index = @selected_countries.indexOf(country)
    if index is -1
      @last_selected_country = country
      @selected_countries.push country
      if @selected_countries.length > 5
        @selected_countries.shift()
    else
      @selected_countries.splice index, 1
      [..., last] = @selected_countries
      @last_selected_country = if last? then last else null


    @selected_countries_codes = (c.code for c in @selected_countries)

    $scope.$state.go("graph", {countries: @selected_countries_codes.join('-')});

    #@loadChart()



  @toggleCountrySelect = (event) ->
    vm.countrySelectOpened = not vm.countrySelectOpened
    # Important part in the implementation
    # Stopping event propagation means window.onclick
    # won't get called when someone clicks
    # on the menu div. Without this, menu will be hidden immediately
    event.stopPropagation()

  @toggleCountryHeaderSelect = (event) ->
    vm.countrySelectHeaderOpened = not vm.countrySelectHeaderOpened
    # Important part in the implementation
    # Stopping event propagation means window.onclick
    # won't get called when someone clicks
    # on the menu div. Without this, menu will be hidden immediately
    event.stopPropagation()

  @statsChartHeight = (people) ->
    max = 1 # avoid 0 division
    for c in @selected_countries
      if c.population > max
        max = c.population

    return Math.round(100*people/max, 0)


  $window.onclick = () ->
    if vm.countrySelectOpened
      vm.countrySelectOpened = false
      # You should let angular know about the update that you have made,
      # so that it can refresh the UI
      $scope.$apply()

    if vm.countrySelectHeaderOpened
      vm.countrySelectHeaderOpened = false
      # You should let angular know about the update that you have made,
      # so that it can refresh the UI
      $scope.$apply()


  @loadCountries = () ->
    @selected_countries = []
    @selected_countries_codes = $scope.$stateParams.countries.split('-')
    for code in @selected_countries_codes
      c = (c for c in $scope.countries when c.code is code)[0]
      if typeof c isnt 'undefined'
        @selected_countries.push c
        if c.id is @last_selected_country?.id
          @last_selected_country = c

    unless @last_selected_country
      [..., @last_selected_country] = @selected_countries


  @last_selected_country = null
  @chartWrapper = null
  @countrySelectOpened = false
  @countrySelectHeaderOpened = false
  @title = 'Dashboard'
  logger.info 'Activated Dashboard'
  @loadCountries()
  @loadChart()



  $scope.$on 'data-loaded', (event, args) =>
    @loadCountries()
    @loadChart()


  $scope.handleDrop = (itemId, binId) =>
    itemId = itemId.replace('country-','')
    binId = binId.replace('country-','')

    item = (c for c in @selected_countries when c.id.toString() is itemId)[0]
    bin = (c for c in @selected_countries when c.id.toString() is binId)[0]

    itemIndex = @selected_countries.indexOf(item)
    binIndex = @selected_countries.indexOf(bin)

    @selected_countries[itemIndex] = bin
    @selected_countries[binIndex] = item

    @selected_countries_codes = (c.code for c in @selected_countries)
    $scope.$state.go("graph", {countries: @selected_countries_codes.join('-')})



  return

Dashboard.$inject = [
  'logger'
  '$scope'
  '$window'
]

angular.module('app.dashboard').controller 'Dashboard', Dashboard
