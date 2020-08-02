import Foundation
import RxTest

/// Strategy to evaluate matching events
public enum MatchingStrategy {
    /// Pass if **single** next event is emitted at expected time with matching value
    case once
    /// Pass if **any** of next events emitted at expected time has a matching value
    case any
    /// Pass if **all** of next events emitted at expected time have a matching value
    case all
}

extension Expectation {
    private func next(at expectedTime: TestTime,
                      strategy: MatchingStrategy,
                      expectedDescription: String,
                      expectedFailureDescription: String,
                      _ valuePredicate: (Element) -> Bool) {
        evaluate { events in
            let matching = events
                .filter {
                    $0.time == expectedTime
                }
                .compactMap { $0.value.element }
            // If no events matching expected time, fail immediately
            guard !matching.isEmpty else {
                return .failure(expected: "to \(expectedFailureDescription) @\(expectedTime)", actual: "no events")
            }
            
            // If single event match, ignore strategy and evaluate directly
            guard matching.count > 1 else {
                return valuePredicate(matching[0]) ?
                    .success("\(expectedDescription) @\(expectedTime)")
                    :
                    .failure(expected: "to \(expectedFailureDescription) @\(expectedTime)", actual: "<\(matching[0])>")
                
            }
            
            // If multiple events occured at expected time, decide based on strategy
            switch strategy {
            case .once:
                return .failure(expected: "to \(expectedFailureDescription) @\(expectedTime)",
                                actual: "<\(matching.map { "\($0)" }.joined(separator: ", "))>")
            case .all:
                guard matching.allSatisfy(valuePredicate) else {
                    return .failure(expected: "to \(expectedFailureDescription) @\(expectedTime)",
                                    actual: "<\(matching.map { "\($0)" }.joined(separator: ", "))>")
                }
            case .any:
                guard matching.contains(where: valuePredicate) else {
                    return .failure(expected: "to \(expectedFailureDescription) @\(expectedTime)",
                                    actual: "<\(matching.map { "\($0)" }.joined(separator: ", "))>")
                }
            }
            return .success("\(expectedDescription) @\(expectedTime)")
        }
    }
}

public extension Expectation {
    /// Expects a testable observer to next given value at expected time
    /// - Parameters:
    ///   - expectedTime: Expected emit time
    ///   - strategy: Matching strategy to evaluate when multiple events are received, defaults to `once`
    ///   - valuePredicate: Predicate to evaluate if event value matches
    func next(at expectedTime: TestTime, strategy: MatchingStrategy = .once,  _ valuePredicate: (Element) -> Bool) {
        next(at: expectedTime,
             strategy: strategy,
             expectedDescription: "next",
             expectedFailureDescription: "next",
             valuePredicate)
    }
}

public extension Expectation where Element: Equatable {
    /// Expects a testable observer to next given value at expected time
    /// - Parameters:
    ///   - expectedValue: Expected emit value
    ///   - expectedTime: Expected emit time
    ///   - strategy: Matching strategy to evaluate when multiple events are received, defaults to `once`
    func next(_ expectedValue: Element, at expectedTime: TestTime, strategy: MatchingStrategy = .once) {
        let description: String
        switch strategy {
        case .once:
            description = "next <\(expectedValue)> once"
        case .all:
            description = "next only <\(expectedValue)>"
        case .any:
            description = "next <\(expectedValue)>"
        }
        next(at: expectedTime, strategy: strategy, expectedDescription: "next <\(expectedValue)>", expectedFailureDescription: description) { $0 == expectedValue}
    }
}
