Stats = ($scope) ->

  $scope.statsChartHeight = (people) ->
    max = 1 # avoid 0 division
    populations = (c.population for c in $scope.countries when $scope.$stateParams.countries.indexOf(c.code) > -1)
    for p in populations
      if p > max
        max = p

    return Math.round(100*people/max, 0)


  return

Stats.$inject = [
  '$scope'
]

angular.module('app.dashboard').controller 'Stats', Stats
