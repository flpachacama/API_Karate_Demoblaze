Feature: Login API

  Background:
    * def users = read('classpath:data/users.json')
    * def userGenerator = call read('classpath:utils/user-generator.js')

  Scenario Outline: Login con diferentes tipos de credenciales
    * def loginUser = userGenerator.signupPayload(users.password)
    * if (<preSignup>) karate.call('classpath:features/helpers/create-user.feature', { user: loginUser })
    * def credentials = { username: '#(loginUser.username)', password: '<password>' }

    Given url demoblazeBaseUrl + '/login'
    And request credentials
    When method post
    Then status 200

    * def loginMessage = response.errorMessage ? response.errorMessage : response
    * def normalizedLoginMessage = (loginMessage + '').replace(/"/g, '').trim()
    * match normalizedLoginMessage contains '<expectedMessage>'
    * assert !<expectsToken> || normalizedLoginMessage.indexOf('Auth_token:') > -1

    Examples:
      | read('classpath:data/login-data.json') |
