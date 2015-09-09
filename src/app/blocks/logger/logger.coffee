### @ngInject ###
logger = ($log) ->
  error = (message, data, title) ->
    $log.error 'Error: ' + message, data
    return

  info = (message, data, title) ->
    $log.info 'Info: ' + message, data
    return

  success = (message, data, title) ->
    $log.info 'Success: ' + message, data
    return

  warning = (message, data, title) ->
    $log.warn 'Warning: ' + message, data
    return

  service =
    error: error
    info: info
    success: success
    warning: warning
    log: $log.log

  return service

logger.$inject = [ '$log' ]

angular.module('blocks.logger').factory 'logger', logger
