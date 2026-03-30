function fn() {
  function randomUser() {
    var token = java.util.UUID.randomUUID().toString().replace('-', '').substring(0, 10);
    return 'qa_' + token;
  }

  return {
    randomUser: randomUser,
    signupPayload: function (password) {
      return {
        username: randomUser(),
        password: password
      };
    }
  };
}
