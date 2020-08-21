import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class ExpectationErrorTests: XCTestCase {
    var sut: TestableObserver<String>!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        sut = scheduler.createObserver(String.self)
    }
    
    // MARK: Match errors
    func test_error_it_succeedsIfErrored() {
        scheduler.bind([.error(10, "some-error")], to: sut)
        scheduler.start()
        then(sut).should.error()
    }
    func test_error_it_handlesNegation() {
        scheduler.bind([.error(10, "some-error")], to: sut)
        scheduler.start()
        failWithMessage("expected not to error") {
            then(sut).shouldNot.error()
        }
    }
    func test_error_it_failsIfNoErrorEvents() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to error") {
            then(sut).should.error()
        }
    }
    
    // MARK: Match error times
    func test_errorAt_it_succeedsIfErroredAtSpecificTime() {
        scheduler.bind([.error(10, "some-error")], to: sut)
        scheduler.start()
        then(sut).should.error(at: 10)
    }
    func test_errorAt_it_handlesNegation() {
        scheduler.bind([.error(10, "some-error")], to: sut)
        scheduler.start()
        failWithMessage("expected not to error @10") {
            then(sut).shouldNot.error(at: 10)
        }
    }
    func test_errorAt_it_failsIfNoErrorEvents() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to error @10") {
            then(sut).should.error(at: 10)
        }
    }
    func test_errorAt_it_failsIfErroredAtDifferentTime() {
        scheduler.bind([.error(20, "some-error")], to: sut)
        scheduler.start()
        failWithMessage("expected to error @10, got error @20") {
            then(sut).should.error(at: 10)
        }
    }
    
    // MARK: Match error values
    func test_errorWith_it_succeedsIfErrorWithMatch() {
        scheduler.bind([.error(10, "some-error")], to: sut)
        scheduler.start()
        then(sut).should.error(with: "some-error")
    }
    func test_errorWith_it_handlesNegation() {
        scheduler.bind([.error(10, "some-error")], to: sut)
        scheduler.start()
        failWithMessage("expected not to error with <some-error>") {
            then(sut).shouldNot.error(with: "some-error")
        }
    }
    func test_errorWith_it_failsIfNoErrorEvents() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to error with <some-error>") {
            then(sut).should.error(with: "some-error")
        }
    }
    func test_errorWith_it_failsIfDifferentError() {
        scheduler.bind([.error(10, "another-error")], to: sut)
        scheduler.start()
        failWithMessage("expected to error with <some-error>, got <another-error>") {
            then(sut).should.error(with: "some-error")
        }
    }
    // MARK: Match error values with time
    func test_errorWithAt_it_succeedsIfErrorWithMatch() {
        scheduler.bind([.error(10, "some-error")], to: sut)
        scheduler.start()
        then(sut).should.error(with: "some-error", at: 10)
    }
    func test_errorWithAt_it_handlesNegation() {
        scheduler.bind([.error(10, "some-error")], to: sut)
        scheduler.start()
        failWithMessage("expected not to error with <some-error> @10") {
            then(sut).shouldNot.error(with: "some-error", at: 10)
        }
    }
    func test_errorWithAt_it_failsIfNoErrorEvents() {
        scheduler.bind([.next(10, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected to error with <some-error> @10") {
            then(sut).should.error(with: "some-error", at: 10)
        }
    }
    func test_errorWithAt_it_failsIfDifferentError() {
        scheduler.bind([.error(10, "another-error")], to: sut)
        scheduler.start()
        failWithMessage("expected to error with <some-error> @10, got <another-error>") {
            then(sut).should.error(with: "some-error", at: 10)
        }
    }
    func test_errorWithAt_it_failsIfDifferentTime() {
        scheduler.bind([.error(20, "some-error")], to: sut)
        scheduler.start()
        failWithMessage("expected to error with <some-error> @10, got @20") {
            then(sut).should.error(with: "some-error", at: 10)
        }
    }
}

extension String: Error {}
