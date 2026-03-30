Feature: Login API

  Background:
    * def users = read('classpath:data/users.json')
    * def userGenerator = call read('classpath:utils/user-generator.js')
    * def extractMessage =
      """
      function(res){
        if (res == null) return '';
        var out = '';
        if (typeof res === 'string') out = res;
        else if (res.errorMessage) out = res.errorMessage;
        else if (res.message) out = res.message;
        else out = karate.pretty(res);
        out = out.trim();
        if (out.length >= 2 && out.charAt(0) == '"' && out.charAt(out.length - 1) == '"') {
          out = out.substring(1, out.length - 1);
        }
        return out.trim();
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
    * def loginMessage = extractMessage(response)
    And match loginMessage contains 'Auth_token:'
    * def token = loginMessage.replace('Auth_token:', '').trim()
    And match token == '#string'
    * assert token.length > 0

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
