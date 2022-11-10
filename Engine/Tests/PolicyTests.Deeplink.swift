extension PolicyTests {
    final class Deeplink: PolicyTests {
        func testDeeplink() {
            test(expected: .deeplink, for: [
                "some://www.ecosia.org",
                "apps://www.theguardian.com/email/form/footer/today-uk",
                "sms://uk.reuters.com/",
                "dsddasdsa://"
            ])
        }
    }
}
