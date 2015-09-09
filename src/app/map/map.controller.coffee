Map = ($state, dataservice, logger) ->
    vm = this
    vm.title = 'Map'
    return

angular.module('app.map').controller 'Map', Map
Map.$inject = [
    '$state'
    'dataservice'
    'logger'
]
