Feature: generated .document
  In order to easily generate RDoc
  A user should be able to
  generate reasonable .document file

  Scenario: .document
    Given a working directory
    And I have configured git sanely
    When I generate a project named 'the-perfect-gem' that is 'zomg, so good'
    Then '.document' contains 'README.rdoc'
    And '.document' contains regex 'lib\/\*\*\/\*.rb'
    And '.document' contains regex 'bin\/\*'
    And '.document' contains regex 'features\/\*\*\/\*.feature'
    And '.document' contains 'LICENSE'
