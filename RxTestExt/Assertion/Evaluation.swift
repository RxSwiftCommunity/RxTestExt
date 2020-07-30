import Foundation
import XCTest

/// Assertion evaluation result
public enum Evaluation {
    /// Evaluation passed
    case success(_ message: String)
    /// Evaluation failed
    ///
    /// Failure message with predefined format is used
    case failure(expected: CustomStringConvertible, actual: CustomStringConvertible)
    /// Evaulation failed
    ///
    /// Custom failure messafge provided is used
    case customFailure(message: String)
    
    // Wrapping `XCTFail` to enable testing assertions
    typealias AssertionHandler = (String, StaticString, UInt) -> Void
    static var assertionHandler: AssertionHandler = XCTFail
}

internal extension Evaluation {
    func verify(negated: Bool, file: StaticString = #file, line: UInt = #line) {
        switch (negated, self) {
        case (false, .success),
             (true, .failure),
             (true, .customFailure):
            break
        case (true, let .success(message)):
            Evaluation.assertionHandler("expected not to \(message)", file, line)
        case (false, let .failure(expected, actual)):
            Evaluation.assertionHandler("expected \(expected), got \(actual)", file, line)
        case (false, let .customFailure(message)):
            Evaluation.assertionHandler(message, file, line)
        }
    }
}

