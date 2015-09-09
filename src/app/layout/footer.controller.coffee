Footer = ($state, $window) ->
  vm = this

  @year = (new Date()).getFullYear()

  @goToTop = ->
    event.stopPropagation()

  return

angular.module('app.layout').controller 'Footer', Footer
Footer.$inject = [
  '$state'
  '$window'
]
