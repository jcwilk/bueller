Feature: bumping version

  Scenario: major version
    Given a working directory
    And I use the existing project "existing-project" as a template
    And 'lib/existing-project/version.rb' contains '1.5.3'
    When I run "rake version:bump:major" in "existing-project"
    Then the process should exit cleanly
    And the updated version, 2.0.0, is displayed
    And 'lib/existing-project/version.rb' contains '2.0.0'

  Scenario: minor version
    Given a working directory
    And I use the existing project "existing-project" as a template
    And 'lib/existing-project/version.rb' contains '1.5.3'
    When I run "rake version:bump:minor" in "existing-project"
    Then the process should exit cleanly
    And the updated version, 1.6.0, is displayed
    And 'lib/existing-project/version.rb' contains '1.6.0'

  Scenario: patch version
    Given a working directory
    And I use the existing project "existing-project" as a template
    And 'lib/existing-project/version.rb' contains '1.5.3'
    When I run "rake version:bump:patch" in "existing-project"
    Then the process should exit cleanly
    And the updated version, 1.5.4, is displayed
    And 'lib/existing-project/version.rb' contains '1.5.4'

  Scenario: arbitrary version
    Given a working directory
    And I use the existing project "existing-project" as a template
    And 'lib/existing-project/version.rb' contains '1.5.3'
    When I run "rake version:write MAJOR=3 MINOR=7 PATCH=1" in "existing-project"
    Then the process should exit cleanly
    And the updated version, 3.7.1, is displayed
    And 'lib/existing-project/version.rb' contains '3.7.1'

  Scenario: arbitrary version with a build version plaintext
    Given a working directory
    And I use the existing project "existing-project" as a template
    And 'lib/existing-project/version.rb' contains '1.5.3'
    When I run "rake version:write MAJOR=3 MINOR=7 PATCH=1 BUILD=2" in "existing-project"
    Then the process should exit cleanly
    And the updated version, 3.7.1.2, is displayed
    And 'lib/existing-project/version.rb' contains '3.7.1.2'
