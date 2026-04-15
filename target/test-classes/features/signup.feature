Feature: Signup API

  Background:
    * def users = read('classpath:data/users.json')
    * def userGenerator = call read('classpath:utils/user-generator.js')

  Scenario Outline: Signup con distintos resultados de negocio
    * def signupUser = userGenerator.signupPayload(users.password)
    * def firstSignup = karate.call('classpath:features/helpers/create-user.feature', { user: signupUser })
    * def finalSignup = <duplicate> ? karate.call('classpath:features/helpers/create-user.feature', { user: signupUser }) : firstSignup
    * def signupMessage = finalSignup.response.errorMessage ? finalSignup.response.errorMessage : finalSignup.response
    * def normalizedSignupMessage = (signupMessage + '').replace(/"/g, '').trim()
    * def effectiveSignupMessage = <allowEmptyResponse> && normalizedSignupMessage == '' ? 'Sign up successful' : normalizedSignupMessage
    * match effectiveSignupMessage contains '<expectedMessage>'

    Examples:
      | read('classpath:data/signup-data.json') |
