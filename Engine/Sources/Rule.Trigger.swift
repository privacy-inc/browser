extension Rule {
    enum Trigger: Equatable {
        case
        all,
        scripts,
        url(Allowed)
    }
}
