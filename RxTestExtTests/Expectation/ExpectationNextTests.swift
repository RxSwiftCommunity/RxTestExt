import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class ExpectationNextTests: XCTestCase {

    var sut: TestableObserver<String>!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        sut = scheduler.createObserver(String.self)
    }
    
    // MARK: Match Single value (Only)
    func test_next_it_succeedsIfMatchingAtSameTime() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        then(sut).should.next("foo", at: 10)
    }
    func test_next_it_handlesNegation() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected not to next <foo> @10") {
            then(sut).shouldNot.next("foo", at: 10)
        }
    }
    func test_next_it_failsIfNoNextEvents() {
        scheduler.bind([.completed(10)], to: sut)
        scheduler.start()
        failWithMessage("expected to next <foo> once @10, got no events") {
            then(sut).should.next("foo", at: 10)
        }
    }
    func test_next_it_failsIfNotMatchingAtSameTime() {
        scheduler.bind([.next(10, "bar")], to: sut)
        scheduler.start()
        failWithMessage("expected to next <foo> once @10, got <bar>") {
            then(sut).should.next("foo", at: 10)
        }
    }
    func test_next_it_failsIfHavingMultipleEvents() {
        scheduler.bind([.next(10, "foo"), .next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to next <foo> once @10, got <foo, foo>") {
            then(sut).should.next("foo", at: 10, strategy: .once)
        }
    }
    // MARK: Match All
    func test_next_it_succeedsIfMatchingAll() {
        scheduler.bind([.next(10, "foo"), .next(10, "foo")], to: sut)
        scheduler.start()
        then(sut).should.next("foo", at: 10, strategy: .all)
    }
    func test_next_it_handlesNegationForAllMatcher() {
        scheduler.bind([.next(10, "foo"), .next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected not to next <foo> @10") {
            then(sut).shouldNot.next("foo", at: 10, strategy: .all)
        }
    }
    func test_next_it_failsIfNotMatchingAll() {
        scheduler.bind([.next(10, "foo"), .next(10, "bar")], to: sut)
        scheduler.start()
        failWithMessage("expected to next only <foo> @10, got <foo, bar>") {
            then(sut).should.next("foo", at: 10, strategy: .all)
        }
    }
 
    // MARK: Match Any
    func test_next_it_succeedsIfMatchingAny() {
        scheduler.bind([.next(10, "foo"), .next(10, "bar")], to: sut)
        scheduler.start()
        then(sut).should.next("foo", at: 10, strategy: .any)
    }
    
    func test_next_it_handlesNegationForAnyMatcher() {
        scheduler.bind([.next(10, "foo"), .next(10, "bar")], to: sut)
        scheduler.start()
        failWithMessage("expected not to next <foo> @10") {
            then(sut).shouldNot.next("foo", at: 10, strategy: .any)
        }
    }
    func test_next_it_failsIfNotMatchingAny() {
        scheduler.bind([.next(10, "foo"), .next(10, "bar")], to: sut)
        scheduler.start()
        failWithMessage("expected to next <baz> @10, got <foo, bar>") {
            then(sut).should.next("baz", at: 10, strategy: .any)
        }
    }
    func test_next_it_failsIfNotMatchingAnyFromSingleValue() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to next <baz> @10, got <foo>") {
            then(sut).should.next("baz", at: 10, strategy: .any)
        }
    }
}
