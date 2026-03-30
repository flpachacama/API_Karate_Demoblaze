Feature: Signup API

  Background:
    * def users = read('classpath:data/users.json')
    * def userGenerator = call read('classpath:utils/user-generator.js')
    * def extractMessage =
      """
      function(res){
        if (res == null) return '';
        if (typeof res === 'string') return res;
        if (res.errorMessage) return res.errorMessage;
        if (res.message) return res.message;
        return karate.pretty(res);
      }
      """

  Scenario: Crear un nuevo usuario en signup
    * def signupUser = userGenerator.signupPayload(users.password)
    Given url demoblazeBaseUrl + '/signup'
    And request signupUser
    When method post
    Then status 200
    * def signupMessage = extractMessage(response)
    And match signupMessage contains 'Sign up successful'

  Scenario: Intentar crear un usuario ya existente
    * def existingUser = userGenerator.signupPayload(users.password)

    Given url demoblazeBaseUrl + '/signup'
    And request existingUser
    When method post
    Then status 200

    Given url demoblazeBaseUrl + '/signup'
    And request existingUser
    When method post
    Then status 200
    * def duplicateMessage = extractMessage(response)
    And match duplicateMessage contains 'This user already exist'
