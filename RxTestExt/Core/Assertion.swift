import XCTest
import RxSwift
import RxTest

func haveNext<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return events.first?.value.element != nil
}

func haveError<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return events.last?.value.error != nil
}

func haveCompleted<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return events.last?.value.isCompleted ?? false
}

public struct Assertion<T> {
    struct Location {
        let file: StaticString
        let line: UInt
    }

    let base: TestableObserver<T>
    let location: Location
    init(_ base: TestableObserver<T>, file: StaticString, line: UInt) {
        self.base = base
        self.location = Location(file: file, line: line)
    }

    func verify(pass: Bool, message: String) {
        if !pass {
            XCTFail("expected to \(message)", file: location.file, line: location.line)
        }
    }

    var events: [Recorded<Event<T>>] {
        return base.events
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
