function fn() {
  var env = karate.env || 'qa';

  var environments = {
    qa: {
      demoblazeBaseUrl: 'https://api.demoblaze.com'
    }
  };

  var selectedEnv = environments[env] || environments.qa;

  var config = {
    env: env,
    demoblazeBaseUrl: selectedEnv.demoblazeBaseUrl,
    defaultHeaders: {
      Accept: 'application/json',
      'Content-Type': 'application/json'
    }
  };

  karate.configure('headers', config.defaultHeaders);
  karate.configure('connectTimeout', 15000);
  karate.configure('readTimeout', 15000);

  return config;
}
