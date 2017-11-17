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

    /// A matcher that succeeds when testable observer terminated with an error event
    public func error() {
        verify(pass: events.last?.value.error != nil,
               message: "error")
    }

    /// A matcher that succeeds when testable observer terminated with a complete event
    public func complete() {
        verify(pass: events.last?.value.isCompleted ?? false,
               message: "complete")
    }
}
