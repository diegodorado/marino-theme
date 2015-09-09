### @ngInject ###
Shell = ($timeout, config, logger) ->
    vm = this

    activate = ->
        logger.success config.appTitle + ' loaded!', null
        hideSplash()

    hideSplash = ->
        #Force a 1 second delay so we can see the splash.
        $timeout (->
            vm.showSplash = false
            return
        ), 1000

    vm.title = config.appTitle
    vm.busyMessage = 'Please wait ...'
    vm.isBusy = true
    vm.showSplash = true
    vm.tagline =
        text: 'Created by John Papa'
        link: 'http://twitter.com/john_papa'
    activate()

angular.module('app.layout').controller 'Shell', Shell
Shell.$inject = [
    '$timeout'
    'config'
    'logger'
]
