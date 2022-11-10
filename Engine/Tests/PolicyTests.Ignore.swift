extension PolicyTests {
    final class Ignore: PolicyTests {
        func testIgnore() {
            test(expected: .ignore, for: [
                "about:blank",
                "about:srcdoc",
                "adsadasdddsada",
                "https:///",
                "https://dfddasadas",
                "blob:https://peech2eecha.com/d145ddd3-2e9d-435e-93e9-750978df7455"
            ])
        }
    }
}
