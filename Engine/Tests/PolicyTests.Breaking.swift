extension PolicyTests {
    final class Breaking: PolicyTests {
        func testBreaking() {
            test(expected: .allow, for: [
                "https://consent.youtube.com/m?continue=https%3A%2F%2Fwww.youtube.com%2F&gl=DE&m=0&pc=yt&uxe=23983172&hl=en-GB&src=1",
                "https://consent.google.com/?hl=en&origin=https://www.google.com&continue=https://www.google.com/search?q%3Dweather%2Bberlin&if=1&m=0&pc=s&wp=-1&gl=GR",
                "https://giphy.com/search/kitten-kiss",
                "https://1und1.de/"
            ])
        }
    }
}
