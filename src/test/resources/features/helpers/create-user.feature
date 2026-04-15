Feature: Helper para crear usuarios

  Scenario: Crear usuario en signup
    Given url demoblazeBaseUrl + '/signup'
    And request user
    When method post
    Then status 200
