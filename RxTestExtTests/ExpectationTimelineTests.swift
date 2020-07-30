import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class ExpectationTimelineTests: XCTestCase {

    var sut: TestableObserver<String>!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        sut = scheduler.createObserver(String.self)
    }
    
    func test_macthTimeline_when_matched_it_suceeds() {
        let events: [Recorded<Event<String>>] = [
            .next(10, "foo"),
            .next(20, "bar"),
            .completed(30),
        ]
        scheduler
            .bind([
                .next(10, "foo"),
                .next(20, "bar"),
                .completed(30),
            ],
            to: sut)
        scheduler.start()
        then(sut).should.matchTimeline(events)
    }
    func test_macthTimeline_when_matched_it_negates() {
        let events: [Recorded<Event<String>>] = [
            .next(10, "foo"),
            .next(20, "bar"),
            .completed(30),
        ]
        scheduler
            .bind([
                .next(10, "foo"),
                .next(20, "bar"),
                .completed(30),
            ],
            to: sut)
        scheduler.start()
        failWithMessage("expected not to match given timeline") {
            then(sut).shouldNot.matchTimeline(events)
        }
    }
    func test_matchTimeline_when_different_it_fails() {
        let events: [Recorded<Event<String>>] = [
            .next(10, "foo"),
            .next(20, "bar"),
            .completed(30),
        ]
        scheduler
            .bind([
                .next(10, "foo"),
                .error(20, TestError(""))
            ],
            to: sut)
        scheduler.start()
        failWithMessage("expected <foo-bar-|>, got <foo-x>") {
            then(sut).should.matchTimeline(events)
        }
    }
    
    // MARK: Never
    func test_never_it_succeedWhenMatchNever() {
        scheduler.bind(.never(), to: sut)
        scheduler.start()
        then(sut).should.beNever()
    }
    func test_never_it_handlesNegation() {
        scheduler.bind(.never(), to: sut)
        scheduler.start()
        failWithMessage("expected not to emit ever") {
            then(sut).shouldNot.beNever()
        }
    }
    func test_never_it_failsWhenEventsRecieved() {
        scheduler.bind([.next(0, "foo")], to: sut)
        scheduler.start()
        failWithMessage("expected no events, got 1 events") {
            then(sut).should.beNever()
        }
    }
    // MARK: Empty
    func test_empty_it_suceedsWhenMatchEmpty() {
        scheduler.bind(.empty(), to: sut)
        scheduler.start()
        then(sut).should.beEmpty()
    }
    func test_empty_it_handlesNegation() {
        scheduler.bind(.empty(), to: sut)
        scheduler.start()
        failWithMessage("expected not to be empty") {
            then(sut).shouldNot.beEmpty()
        }
    }
    func test_empty_it_failsWhenNoEventsReceived() {
        scheduler.bind([], to: sut)
        scheduler.start()
        failWithMessage("expected to only complete, got <>") {
            then(sut).should.beEmpty()
        }
    }
    func test_empty_it_failsWhenNextEventsReceived() {
        scheduler.bind([.next(10, "foo"), .completed(10)], to: sut)
        scheduler.start()
        failWithMessage("expected to only complete, got <foo-|>") {
            then(sut).should.beEmpty()
        }
    }
    func test_empty_it_failsWhenErrorEventReceived() {
        scheduler.bind([.error(10, TestError(""))], to: sut)
        scheduler.start()
        failWithMessage("expected to only complete, got <x>") {
            then(sut).should.beEmpty()
        }
    }
    // MARK: Just
    func test_beJust_it_succeedsWhenMatchJust() {
        scheduler.bind(.just("foo"), to: sut)
        scheduler.start()
        then(sut).should.beJust("foo")
    }
    func test_beJust_it_handlesNegation() {
        scheduler.bind(.just("foo"), to: sut)
        scheduler.start()
        failWithMessage("expected not to be just <foo>") {
            then(sut).shouldNot.beJust("foo")
        }
    }
    func test_beJust_it_handlesFailures() {
        scheduler.bind([.next(10, "foo"), .next(20, "bar")], to: sut)
        scheduler.start()
        failWithMessage("expected to emit <foo> and complete, got <foo-bar>") {
            then(sut).should.beJust("foo")
        }
    }
    // MARK: Start With
    func test_startWith_it_succeedsWhenMatchStartWith() {
        scheduler.bind(Observable.just("foo").startWith("start"), to: sut)
        scheduler.start()
        then(sut).should.startWith("start")
    }
    func test_startWith_it_handlesNegation() {
        scheduler.bind(Observable.just("foo").startWith("start"), to: sut)
        scheduler.start()
        failWithMessage("expected not to start with <start>") {
            then(sut).shouldNot.startWith("start")
        }
    }
    func test_startWith_it_handlesFailuresWhenStartedWithDifferentValue() {
        scheduler.bind([.next(10, "foo"), .next(20, "bar")], to: sut)
        scheduler.start()
        failWithMessage("expected to start with <start>, got <foo>") {
            then(sut).should.startWith("start")
        }
    }
    func test_startWith_it_handlesFailuresWhenStartedWithNoValue() {
        scheduler.bind([.completed(10)], to: sut)
        scheduler.start()
        failWithMessage("expected to start with <start>, got nothing") {
            then(sut).should.startWith("start")
        }
    }
}
