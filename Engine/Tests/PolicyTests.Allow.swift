extension PolicyTests {
    final class Allow: PolicyTests {
        func testAllow() {
            test(expected: .allow, for: [
                "https://www.ecosia.org",
                "https://www.theguardian.com/email/form/footer/today-uk",
                "https://uk.reuters.com/",
                "data:text/html;charset=utf-8;base64,PGltZyBzcmM9Imh0dHBzOi8vd3d3LmJldDM2NS5jb20vZmF2aWNvbi5pY28iPg==",
                "file:///Users/some/Downloads/index.html",
                "https://consent.yahoo.com/v2/collectConsent?sessionId=3_cc-session_d5551c9f-5d07-4428-b0f9-6e92b1c3ca4e",
                "https://something.com/account/to",
                "https://something.com/embed/to",
                "https://avocado.com/embed",
                "https://www.youtube.com/embed/gzAoi9Xdm-A?embed_config=%7B%22adsConfig%22:%7B%22adTagParameters%22:%7B%22iu%22:%22/59666047/theguardian.com/media/article/ng%22,%22cust_params%22:%22sens%3Df%26si%3Df%26vl%3D0%26cc%3DINT%26s%3Dmedia%26inskin%3Df%26ct%3Darticle%26co%3Dmarksweney%26url%3D%252Fmedia%252F2021%252Fjun%252F18%252Fcoca-colas-ronaldo-fiasco-highlights-risk-to-brands-in-social-media-age%26su%3D3%2C4%2C5%26edition%3Dint%26tn%3Dfeatures%26p%3Dng%26k%3Dbusiness%2Csport%2Ceuropean-championship%2Cmedia%2Cronaldo%2Cfootball%2Ccocacola%2Ceuro-2020%2Cfooddrinks%2Cadvertising%26sh%3Dhttps%253A%252F%252Fwww.theguardian.com%252Fp%252Fhzhjv%26pa%3Df%22%7D%7D%7D&enablejsapi=1&origin=https://www.theguardian.com&widgetid=1&modestbranding=1",
                "https://www.spiegel.de/consent-a-?targetUrl=https%3A%2F%2Fwww.spiegel.de%2F"
            ])
        }
    }
}
