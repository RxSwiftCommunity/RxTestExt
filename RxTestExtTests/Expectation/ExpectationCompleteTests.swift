import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class ExpectationCompleteTests: XCTestCase {
    var sut: TestableObserver<String>!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        sut = scheduler.createObserver(String.self)
    }
    
    // MARK: Match completion
    func test_complete_it_succeedsIfCompleted() {
        scheduler.bind([.completed(10)], to: sut)
        scheduler.start()
        then(sut).should.complete()
    }
    func test_complete_it_handlesNegation() {
        scheduler.bind([.completed(10)], to: sut)
        scheduler.start()
        failWithMessage("expected not to complete") {
            then(sut).shouldNot.complete()
        }
    }
    func test_complete_it_failsIfNoCompleteEvents() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to complete") {
            then(sut).should.complete()
        }
    }
    
    // MARK: Match completion with time
    func test_completeAt_it_succeedsIfCompletedAtSpecificTime() {
        scheduler.bind([.completed(10)], to: sut)
        scheduler.start()
        then(sut).should.complete(at: 10)
    }
    func test_completeAt_it_handlesNegationAtSpecificTime() {
        scheduler.bind([.completed(10)], to: sut)
        scheduler.start()
        failWithMessage("expected not to complete @10") {
            then(sut).shouldNot.complete(at: 10)
        }
    }
    func test_completeAt_it_failsIfNoCompleteEvents() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to complete @10") {
            then(sut).should.complete(at: 10)
        }
    }
    func test_completeAt_it_failsIfCompletedAtDifferentTime() {
        scheduler.bind([.completed(10)], to: sut)
        scheduler.start()
        failWithMessage("expected to complete @20, got completed @10") {
            then(sut).should.complete(at: 20)
        }
    }
    
    // MARK: Match completion after count
    func test_completeAfter_it_succeedsIfCompletedAfterGivenCount() {
        scheduler.bind([.next(10, "foo"), .completed(10)], to: sut)
        scheduler.start()
        then(sut).should.complete(after: 1)
    }
    func test_completeAfter_it_handlesNegation() {
        scheduler.bind([.next(10, "foo"), .completed(10)], to: sut)
        scheduler.start()
        failWithMessage("expected not to complete after <1> events") {
            then(sut).shouldNot.complete(after: 1)
        }
    }
    func test_completeAfter_it_failsIfNotComplete() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to complete after <1> events, got no complete events") {
            then(sut).should.complete(after: 1)
        }
    }
    func test_completeAfter_it_failsIfCompletedAfterDifferentCount() {
        scheduler.bind([.next(10, "foo"), .next(20, "bar"), .completed(30)], to: sut)
        scheduler.start()
        failWithMessage("expected to complete after <1> events, got complete after <2> events") {
            then(sut).should.complete(after: 1)
        }
    }
}
