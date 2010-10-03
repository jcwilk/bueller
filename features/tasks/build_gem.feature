Feature: building gems

  Scenario: default
    Given a working directory
    And I use the existing project "existing-project" as a template
    And 'existing-project.gemspec' contains '1.5.3'
    And "existing-project/pkg/existing-project-1.5.3.gem" does not exist
    When I run "rake build" in "existing-project"
    Then I can gem install "existing-project/pkg/existing-project-1.5.3.gem"
