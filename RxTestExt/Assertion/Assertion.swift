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

public extension Assertion {
    var should: Expectation<T> {
        Expectation(assertion: self, negated: false)
    }
    
    var shouldNot: Expectation<T> {
        Expectation(assertion: self, negated: true)
    }
}
