Feature: generated Rakefile
  In order to start a new gem
  A user should be able to
  generate a gemspec

  Background:
    Given a working directory
    And I have configured git sanely

  Scenario: shared
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good' and described as 'Descriptive'
    Then the gemspec has 'version' set to '0.0.0'
    And the gemspec has 'authors' set to 'foo'
    And the gemspec has 'email' set to 'bar@example.com'
    And the gemspec has 'homepage' set to 'http://github.com/technicalpickles/the-perfect-gem'

  Scenario: bacon
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has 'test_files' set to 'spec/**/*_spec.rb'
    And the gemspec has development dependency 'bacon'

  Scenario: minitest
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has 'test_files' set to 'test/**/test_*.rb'
    And the gemspec has development dependency 'minitest'

  Scenario: rspec
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has 'test_files' set to 'spec/**/*_spec.rb'
    And the gemspec has development dependency 'rspec'

  Scenario: shoulda
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has 'test_files' set to 'test/**/test_*.rb'
    And the gemspec has development dependency 'shoulda'

  Scenario: micronaut
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has 'test_files' set to 'examples/**/*_example.rb'
    And the gemspec has development dependency 'micronaut'

  Scenario: testunit
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then the gemspec has 'test_files' set to 'test/**/test_*.rb'

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
