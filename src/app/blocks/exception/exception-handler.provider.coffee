# Include in index.html so that app level exceptions are handled.
# Exclude from testRunner.html which should run exactly what it wants to run

###*
# Must configure the exception handling
# @return {[type]}
###
exceptionHandlerProvider = ->

  ### jshint validthis:true ###
  @config = appErrorPrefix: undefined

  @configure = (appErrorPrefix) ->
    @config.appErrorPrefix = appErrorPrefix
    return

  @$get = ->
    { config: @config }

  return
  
###*
# Extend the $exceptionHandler service to also display a toast.
# @param  {Object} $delegate
# @param  {Object} exceptionHandler
# @param  {Object} logger
# @return {Function} the decorated $exceptionHandler service
###

### @ngInject ###
extendExceptionHandler = ($delegate, exceptionHandler, logger) ->
  (exception, cause) ->
    appErrorPrefix = exceptionHandler.config.appErrorPrefix or ''
    errorData =
      exception: exception
      cause: cause
    exception.message = appErrorPrefix + exception.message
    $delegate exception, cause

    ###*
    # Could add the error to a service's collection,
    # add errors to $rootScope, log errors to remote web server,
    # or log locally. Or throw hard. It is entirely up to you.
    # throw exception;
    #
    # @example
    #     throw { message: 'error message we added' };
    ###

    logger.error exception.message, errorData
    return

extendExceptionHandler.$inject = [
    '$delegate'
    'exceptionHandler'
    'logger'
]

###*
# Configure by setting an optional string value for appErrorPrefix.
# Accessible via config.appErrorPrefix (via config value).
# @param  {[type]} $provide
# @return {[type]}
# @ngInject
###
config = ($provide) ->
  $provide.decorator '$exceptionHandler', extendExceptionHandler
  return
config.$inject = [ '$provide' ]


angular.module('blocks.exception')
  .provider('exceptionHandler', exceptionHandlerProvider)
  .config config
