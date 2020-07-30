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
}
