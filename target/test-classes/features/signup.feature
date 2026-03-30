Feature: Signup API

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

  Scenario: Crear un nuevo usuario en signup
    * def signupUser = userGenerator.signupPayload(users.password)
    Given url demoblazeBaseUrl + '/signup'
    And request signupUser
    When method post
    Then status 200
    * def signupMessage = extractMessage(response)
    * assert signupMessage == '' || signupMessage.indexOf('Sign up successful') > -1

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
