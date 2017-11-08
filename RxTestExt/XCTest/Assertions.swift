import XCTest
import RxTest

/// Assert subject has recieved any next events
///
/// - Parameters:
///   - subject: testable observer with recorded events
///   - message: message to show if test failed. If nil, a default message "did not send any next events" will be used.
public func AssertSentNext<T>(_ subject: TestableObserver<T>, _ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
    let nextEvents = subject.events.filter { $0.value.element != nil }
    verify(pass: !nextEvents.isEmpty,
           message: message ?? "did not send any next events",
           file: file, line: line)
}

/// Assert subject has terminated with an error event
///
/// - Parameters:
///   - subject: testable observer with recorded events
///   - message: message to show if test failed. If nil, a default message "did not send any next events" will be used.
public func AssertError<T>(_ subject: TestableObserver<T>, _ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
    let errorEvents = subject.events.filter { $0.value.error != nil }
    verify(pass: !errorEvents.isEmpty,
           message: message ?? "did not error",
           file: file, line: line)

}

/// Assert subject has terminated with a complete event
///
/// - Parameters:
///   - subject: testable observer with recorded events
///   - message: message to show if test failed. If nil, a default message "did not send any next events" will be used.
public func AssertComplete<T>(_ subject: TestableObserver<T>, _ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
    let completeEvents = subject.events.filter { $0.value.isCompleted }
    verify(pass: !completeEvents.isEmpty,
           message: message ?? "did not complete",
           file: file, line: line)
}

internal func verify(pass: Bool, message: String, file: StaticString, line: UInt) {
    if !pass {
        XCTFail(message, file: file, line: line)
    }
}

