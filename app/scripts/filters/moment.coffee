'use strict'

###*
 # @ngdoc filter
 # @name racingApp.filter:moment
 # @function
 # @description
 # # moment
 # Filter in the racingApp.
###
angular.module('racingApp').filter 'duration', (options, $filter) ->
  (input, unitOfTime, template, precision) ->
    if input is Infinity
      return ''
    if input.toNumber?
      input = input.toNumber()
    return '' if not input
    nonexact = if input?.nonexact?  and input.nonexact then ' or less' else ''
    duration = moment.duration input, unitOfTime
    if not template?
      template = 'd[d] h:mm:ss'
      switch options.durationFormat?()
        when 'human' then return nonexact + duration.humanize()
        when 'full'
          template = switch
            when duration.asSeconds() < 60 then '0:s'
            else 'y [yr] M [mth] d [day] hh:mm:ss'
        when 'abbreviated'
          if duration.asYears() >= 100
            years = $filter('longnum')(duration.asYears())
            return "#{years} years"
          template = switch
            when duration.asYears() >= 1 then 'y [years] M [months]'
            when duration.asMonths() >= 1 then 'M [months] d [days]'
            when duration.asDays() >= 1 then 'd [days] h [hours]'
            when duration.asMinutes() >= 1 then 'h:mm:ss'
            else {template:'00:ss', trim:false}

    return duration.format(template, precision) + nonexact

angular.module('racingApp').filter 'momentFromNow', ($filter) ->
  (input) ->
    return moment(input).fromNow()
