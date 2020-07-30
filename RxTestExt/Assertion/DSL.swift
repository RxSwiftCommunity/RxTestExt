import Foundation
import RxTest

public func assert<T>(_ source: TestableObserver<T>, file: StaticString = #file, line: UInt = #line) -> Assertion<T> {
    return Assertion(source, file: file, line: line)
}
