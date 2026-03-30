Feature: Login API

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

  Scenario: Login con usuario y password correcto
    * def validUser = userGenerator.signupPayload(users.password)

    Given url demoblazeBaseUrl + '/signup'
    And request validUser
    When method post
    Then status 200

    Given url demoblazeBaseUrl + '/login'
    And request validUser
    When method post
    Then status 200
    And match response contains { Auth_token: '#string' }
    And match response.Auth_token == '#notnull'

  Scenario: Login con usuario y password incorrecto
    * def knownUser = userGenerator.signupPayload(users.password)

    Given url demoblazeBaseUrl + '/signup'
    And request knownUser
    When method post
    Then status 200

    * def invalidCredentials = { username: '#(knownUser.username)', password: '#(users.wrongPassword)' }
    Given url demoblazeBaseUrl + '/login'
    And request invalidCredentials
    When method post
    Then status 200
    * def loginErrorMessage = extractMessage(response)
    And match loginErrorMessage contains 'Wrong password'
