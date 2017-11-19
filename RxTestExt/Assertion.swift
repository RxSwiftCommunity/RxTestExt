import XCTest
import RxSwift
import RxTest

public struct Assertion<T> {
    struct Location {
        let file: StaticString
        let line: UInt
    }

    let base: TestableObserver<T>
    let location: Location
    let negated: Bool
    init(_ base: TestableObserver<T>, file: StaticString, line: UInt, negated: Bool = false) {
        self.base = base
        self.location = Location(file: file, line: line)
        self.negated = negated
    }

    func verify(pass: Bool, message: String) {
        if pass == negated {
            XCTFail("expected \(negated ? "not" : "") to \(message)", file: location.file, line: location.line)
        }
    }

    var events: [Recorded<Event<T>>] {
        return base.events
    }

	/// A negated version of current assertion
    public var not: Assertion<T> {
        return Assertion(base, file: location.file, line: location.line, negated: true)
    }
}

public func assert<T>(_ source: TestableObserver<T>, file: StaticString = #file, line: UInt = #line) -> Assertion<T> {
    return Assertion(source, file: file, line: line)
}

extension Assertion {
    /// A matcher that succeeds when testable observer received one (or more) next events
    public func next() {
        verify(pass: events.first?.value.element != nil,
               message: "next")
    }
}

// MARK: Error Matchers
extension Assertion {
    /// A matcher that succeeds when testable observer terminated with an error event
    public func error() {
        verify(pass: events.last?.value.error != nil,
               message: "error")
    }

    /// A matcher that succeeds when testable observer terminated with an error event at a specific test time.
    ///
    /// - Parameter time: Expected error test time.
    public func error(at time: TestTime) {
        guard let errorEvent = events.last, let error = errorEvent.value.error else {
            verify(pass: false, message: "error")
            return
        }
        verify(pass: errorEvent.time == time,
               message: "error at <\(time)>, errored at <\(errorEvent.time)> instead.")
    }
}

// MARK: Completion Matchers
extension Assertion {
    /// A matcher that succeeds when testable observer terminated with a complete event
    public func complete() {
        verify(pass: events.last?.value.isCompleted ?? false,
               message: "complete")
    }

    /// A matcher that succeeds if testable observer terminated with a complete event at a specific test time.
    ///
    /// - Parameter time: Test time to match completion event
    public func complete(at time: TestTime) {
        guard let completeEvent = events.last, completeEvent.value.isCompleted else {
            verify(pass: false,
                   message: "complete")
            return
        }
        verify(pass: completeEvent.time == time,
               message: "complete at <\(time)>, completed at <\(completeEvent.time)> instead")
    }

    /// A matcher that succeeds if testable observer terminated with a complete event after a specific number of next events.
    ///
    /// - Parameter count: Number of next events before complete.
    public func complete(after count: Int) {
        guard let completeEvent = events.last, completeEvent.value.isCompleted else {
            verify(pass: false,
                   message: "complete")
            return
        }
        let actualCount = events.count - 1
        verify(pass: actualCount == count,
               message: "complete after <\(count)>, completed after <\(actualCount)> instead")
    }
}
