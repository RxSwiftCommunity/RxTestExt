import Foundation
import RxTest

public extension Expectation {
    /// Expects a testable observer to eventually complete
    func complete() {
        evaluate { events in
            guard let terminating = events.last,
                  terminating.value.isCompleted else {
                return .customFailure(message: "expected to complete")
            }
            return .success("complete")
        }
    }
    
    /// Expects a testable observer to complete at a given time
    /// - Parameter expectedTime: Expected complete time
    func complete(at expectedTime: TestTime) {
        evaluate { events in
            guard let terminating = events.last,
                  terminating.value.isCompleted else {
                return .customFailure(message: "expected to complete @\(expectedTime)")
            }
            guard terminating.time == expectedTime else {
                return .failure(expected: "to complete @\(expectedTime)", actual: "completed @\(terminating.time)")
            }
            return .success("complete @\(expectedTime)")
        }
    }
    
    /// Expects a testable observer to complete after a given number of next events
    /// - Parameter expectedCount: Count of events before complete
    func complete(after expectedCount: Int) {
        evaluate { events in
            guard let terminating = events.last,
                  terminating.value.isCompleted else {
                return .failure(expected: "to complete after <\(expectedCount)> values", actual: "no complete events")
            }
            
            let actualCount = events.count - 1
            guard actualCount == expectedCount else {
                return .failure(expected: "to complete after <\(expectedCount)> events", actual: "complete after <\(actualCount)> values")
            }
            return .success("complete after <\(expectedCount)> values")
        }
    }
}
