public enum Policy: Equatable {
    case
    deeplink,
    ignore,
    allow,
    app,
    block(String)
}
