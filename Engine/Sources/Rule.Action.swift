extension Rule {
    enum Action {
        case
        block,
        blockCookies,
        makeHttps,
        cssNone(Set<String>)
    }
}
