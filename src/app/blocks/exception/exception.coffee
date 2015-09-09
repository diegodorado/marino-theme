### @ngInject ###
exception = (logger) ->
  catcher = (message) ->
    (reason) ->
      logger.error message, reason

  service = catcher: catcher

  return service

exception.$inject = [ 'logger' ]

angular.module('blocks.exception').factory 'exception', exception
