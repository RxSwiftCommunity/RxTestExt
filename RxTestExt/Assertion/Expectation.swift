import Foundation
import RxSwift
import RxTest

/// A proxy type to allow protocol extension-based matchers
public struct Expectation<Element> {
    let assertion: Assertion<Element>
    let negated: Bool
    
    public func evaluate(_ predicate: ([Recorded<Event<Element>>]) -> Evaluation) {
        let result = predicate(assertion.events)
        result.verify(negated: negated,
                      file: assertion.location.file,
                      line: assertion.location.line)
    }
}
