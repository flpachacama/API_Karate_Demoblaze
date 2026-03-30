package runners;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate runApiTests() {
        return Karate.run("classpath:features/signup", "classpath:features/login");
    }
}
