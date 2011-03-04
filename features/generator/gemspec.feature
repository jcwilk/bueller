Feature: generated Rakefile
  In order to start a new gem
  A user should be able to
  generate a gemspec

  Background:
    Given a working directory
    And I have configured git sanely

  Scenario: shared
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good' and described as 'Descriptive'
    Then the gemspec has 'authors' set to 'foo'
    And the gemspec has 'email' set to 'bar@example.com'
    And the gemspec has 'homepage' set to 'http://github.com/technicalpickles/the-perfect-gem'

  Scenario: cucumber
    Given I want cucumber stories
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has development dependency 'cucumber'

  Scenario: reek
    Given I want reek
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has development dependency 'reek'

  Scenario: roodi
    Given I want roodi
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has development dependency 'roodi'

  Scenario: yard
    Given I want to use yard instead of rdoc
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has development dependency 'yard'

  Scenario: shindo
    When I generate a shindo project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has development dependency 'shindo'
