'use strict'

###*
 # @ngdoc directive
 # @name racingApp.directive:description
 # @description
 #
 # Use either static descriptions from the spreadsheet, or templated descriptions in /app/views/desc.
 # Spreadsheet descriptions of '' or '-' indicate that we should try to use a template.
 # (We used to do stupid $compile tricks to allow templating in the spreadsheet, but that caused memory leaks. #177)
###
angular.module('racingApp').directive 'unitdesc', (game, commands, options) ->
  template: '<p ng-if="templateUrl" ng-include="templateUrl" class="desc desc-unit desc-template desc-{{unit.name}}"></p><p ng-if="!templateUrl" class="desc desc-unit desc-text desc-{{unit.name}}">{{desc}}</p>'
  scope:
    unit: '='
    game: '=?'
  restrict: 'E'
  link: (scope, element, attrs) ->
    scope.game ?= game
    scope.commands = commands
    scope.options = options
    scope.desc = scope.unit.unittype.description
    scope.templateUrl = do ->
      if scope.unit.unittype.template
        return "views/desc/unit/#{scope.unit.unittype.template}.html"
      if scope.desc == '-' or not scope.desc
        return "views/desc/unit/#{scope.unit.name}.html"
      return ''

angular.module('racingApp').directive 'upgradedesc', (game, commands, options) ->
  template: '<p ng-if="templateUrl" ng-include="templateUrl" desc desc-upgrade desc-template desc-{{upgrade.name}}"></p><p ng-if="!templateUrl" class="desc desc-upgrade desc-text desc-{{upgrade.name}}">{{desc}}</p>'
  scope:
    upgrade: '='
    game: '=?'
  restrict: 'E'
  link: (scope, element, attrs) ->
    scope.game ?= game
    scope.commands = commands
    scope.options = options
    scope.desc = scope.upgrade.type.description
    scope.templateUrl = do ->
      if scope.upgrade.type.template
        return "views/desc/upgrade/#{scope.upgrade.type.template}.html"
      if scope.desc == '-' or not scope.desc
        return "views/desc/upgrade/#{scope.upgrade.name}.html"
      return ''
