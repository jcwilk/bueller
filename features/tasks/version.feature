Feature: version rake task

  Scenario: an existing project with version plaintext
    Given a working directory
    And I use the existing project "existing-project" as a template
    When I run "rake version" in "existing-project"
    Then the process should exit cleanly
    And the current version, 1.5.3, is displayed
