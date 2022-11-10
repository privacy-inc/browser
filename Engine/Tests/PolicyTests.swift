import XCTest
@testable import Engine

class PolicyTests: XCTestCase {
    final func test(expected: Policy, for list: [String]) {
        list
            .forEach {
                switch expected {
                case .block:
                    if case .block = URL(string: $0)!.policy {
                        return
                    }
                default:
                    if URL(string: $0)!.policy == expected {
                        return
                    }
                }
                
                XCTFail("\(URL(string: $0)!.policy): \($0)")
            }
    }
}
