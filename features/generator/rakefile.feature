Feature: generated Rakefile
  In order to start a new gem
  A user should be able to
  generate a Rakefile

  Background:
    Given a working directory
    And I have configured git sanely

  Scenario: shared
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good' and described as 'Descriptive'

    Then 'Rakefile' requires 'rubygems'
    And 'Rakefile' requires 'rake'
    And 'Rakefile' requires 'rake/rdoctask'

  Scenario: bacon
    When I generate a bacon project named 'the-perfect-gem' that is 'zomg, so good'


    Then 'Rakefile' requires 'rcov/rcovtask'
    And Rakefile has 'spec/**/*_spec.rb' for the Rake::TestTask pattern
    And Rakefile has 'spec/**/*_spec.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'spec' in the Rcov::RcovTask libs
    And Rakefile has "spec" as the default task

  Scenario: minitest
    When I generate a minitest project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'rcov/rcovtask'
    And Rakefile has 'test/**/test_*.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/test_*.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs
    And Rakefile has "test" as the default task

  Scenario: rspec
    When I generate a rspec project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'rspec/core/rake_task'
    And Rakefile has "examples" as the default task

  Scenario: shoulda
    When I generate a shoulda project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'rcov/rcovtask'
    And Rakefile has 'test/**/test_*.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/test_*.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs
    And Rakefile has "test" as the default task

  Scenario: micronaut
    When I generate a micronaut project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'micronaut/rake_task'
    And Rakefile has 'examples/**/*_example.rb' for the Micronaut::RakeTask pattern
    And Rakefile has "examples" as the default task

  Scenario: testunit
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' requires 'rcov/rcovtask'
    Then Rakefile has 'test/**/test_*.rb' for the Rake::TestTask pattern
    And Rakefile has 'test/**/test_*.rb' for the Rcov::RcovTask pattern
    And Rakefile has 'test' in the Rcov::RcovTask libs
    And Rakefile has "test" as the default task

  Scenario: no cucumber
    Given I do not want cucumber stories
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile does not require 'cucumber/rake/task'
    And Rakefile does not instantiate a Cucumber::Rake::Task

  Scenario: cucumber
    Given I want cucumber stories
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile requires 'cucumber/rake/task'
    And Rakefile instantiates a Cucumber::Rake::Task

  Scenario: no reek
    Given I do not want reek
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile does not require 'reek/adapters/rake_task'
    And Rakefile does not instantiate a Reek::RakeTask

  Scenario: reek
    Given I want reek
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile requires 'reek/adapters/rake_task'
    And Rakefile instantiates a Reek::RakeTask

  Scenario: no roodi
    Given I do not want roodi
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile does not require 'roodi'
    And Rakefile does not require 'roodi_task'
    And Rakefile does not instantiate a RoodiTask

  Scenario: roodi
    Given I want roodi
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'
    Then Rakefile requires 'roodi'
    And Rakefile requires 'roodi_task'
    And Rakefile instantiates a RoodiTask

  Scenario: yard
    Given I want to use yard instead of rdoc
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' does not require 'rake/rdoctask'
    And 'Rakefile' requires 'yard'
    And Rakefile instantiates a YARD::Rake::YardocTask

  Scenario: rdoc
    Given I want to use rdoc instead of yard
    When I generate a testunit project named 'the-perfect-gem' that is 'zomg, so good'

    Then 'Rakefile' does not require 'yard'
    And 'Rakefile' requires 'rake/rdoctask'
    And Rakefile does not instantiate a YARD::Rake::YardocTask
    And Rakefile instantiates a Rake::RDocTask.new

  Scenario: shindo
    When I generate a shindo project named 'the-perfect-gem' that is 'zomg, so good'
    And 'Rakefile' requires 'shindo/rake'
    And Rakefile instantiates a Shindo::Rake.new
    And Rakefile has "tests" as the default task
