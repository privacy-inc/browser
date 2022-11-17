public enum Policy: Equatable, Sendable {
    case
    deeplink,
    ignore,
    allow,
    app,
    block(String)
}
