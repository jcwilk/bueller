Feature: generated Gemfile
  In order to start a new gem
  A user should be able to
  generate a Gemfile

  Background:
    Given a working directory
    And I have configured git sanely

  Scenario: default
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then 'Gemfile' depends on the gemspec
