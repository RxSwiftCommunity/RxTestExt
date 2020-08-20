import Foundation
import RxTest

public extension Expectation {
    func error() {
        evaluate { events in
            guard let terminating = events.last,
                terminating.value.error != nil else {
                return .customFailure(message: "expected to error")
            }
            
            return .success("error")
        }
    }
    
    func error(at expectedTime: TestTime) {
        evaluate { events in
            guard let terminating = events.last,
                  terminating.value.error != nil else {
                return .customFailure(message: "expected to error @\(expectedTime)")
            }
            
            guard terminating.time == expectedTime else {
                return .failure(expected: "to error @\(expectedTime)", actual: "error @\(terminating.time)")
            }
            
            return .success("error @\(expectedTime)")
        }
    }
    
    func error<E: Error>(with expectedError: E) where E: Equatable {
        evaluate { events in
            guard let terminating = events.last,
                  let error = terminating.value.error else {
                return .customFailure(message: "expected to error with <\(expectedError)>")
            }
            guard let actualError = error as? E,
                  actualError == expectedError else {
                return .failure(expected: "to error with <\(expectedError)>", actual: "<\(error)>")
            }
            return .success("error with <\(expectedError)>")
        }
    }
    
    func error<E: Error>(with expectedError: E, at expectedTime: TestTime) where E: Equatable {
        evaluate { events in
            guard let terminating = events.last,
                  let error = terminating.value.error else {
                return .customFailure(message: "expected to error with <\(expectedError)> @\(expectedTime)")
            }
            
            guard let actualError = error as? E,
                  actualError == expectedError else {
                return .failure(expected: "to error with <\(expectedError)> @\(expectedTime)", actual: "<\(error)>")
            }
            
            guard terminating.time == expectedTime else {
                return .failure(expected: "to error with <\(expectedError)> @\(expectedTime)", actual: "@\(terminating.time)")
            }
            
            return .success("error with <\(expectedError)> @\(expectedTime)")
        }
    }
}
