import Foundation

struct TestError: Swift.Error, Equatable, CustomDebugStringConvertible {
    let message: String
    init(_ message: String = "") {
        self.message = message
    }
    public static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.message == rhs.message
    }

    var debugDescription: String {
        return "Error(\(message))"
    }
}
