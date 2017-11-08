import RxTest
import Nimble


/// A nimble matcher that succeeds when testable observer received one (or more) next events
public func sendNext<T>() -> Predicate<TestableObserver<T>> {
    return Predicate { expression in
        guard let events = try expression.evaluate()?.events else {
            return PredicateResult(status: .fail, message: .fail("failed to evaluate expression"))
        }
        let nextEvents = events.filter { $0.value.element != nil }
        return PredicateResult(bool: !nextEvents.isEmpty,
                               message: .expectedTo("receive next events"))
    }
}

/// A nimble matcher that succeeds when testable observer terminated with an error event
public func error<T>() -> Predicate<TestableObserver<T>> {
    return Predicate { expression in
        guard let events = try expression.evaluate()?.events else {
            return PredicateResult(status: .fail, message: .fail("failed to evaluate expression"))
        }
        let errorEvents = events.filter { $0.value.error != nil }
        return PredicateResult(bool: !errorEvents.isEmpty,
                               message: .expectedTo("error"))
    }
}

/// A nimble matcher that succeeds when testable observer terminated with a complete event
public func complete<T>() -> Predicate<TestableObserver<T>> {
    return Predicate { expression in
        guard let events = try expression.evaluate()?.events else {
            return PredicateResult(status: .fail, message: .fail("failed to evaluate expression"))
        }
        let completeEvents = events.filter { $0.value.isCompleted }
        return PredicateResult(bool: !completeEvents.isEmpty,
                               message: .expectedTo("complete"))
    }
}
