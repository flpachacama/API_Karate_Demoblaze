package runners;

import com.intuit.karate.junit5.Karate;

public class TestRunner {

    @Karate.Test
    public Karate runApiTests() {
        return Karate.run("classpath:features/signup.feature", "classpath:features/login.feature");
    }
}