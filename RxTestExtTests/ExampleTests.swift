import Foundation
import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class ExampleTests: XCTestCase {

    var viewModel: ViewModel!
    var scheduler: TestScheduler!
    var events: [Recorded<Event<String>>]!
    override func setUp() {
        super.setUp()
        viewModel = ViewModel()
        scheduler = TestScheduler(initialClock: 0)
        events = []
    }

    func testRecordingAllEvents() {
        events = [.next(10, "alpha"), .completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        XCTAssertEqual(source.events, events)
    }

    func testRecordingAllEventsPublishRelay() {
        events = [.next(10, "alpha")]
        let source = scheduler.record(source: viewModel.publishRelayElements)
        scheduler.bind(events, to: viewModel.publishRelayInput)
        scheduler.start()
        XCTAssertEqual(source.events, events)
    }

    func testRecordingAllEventsBehaviorRelay() {
        events = [.next(10, "alpha")]

        let source = scheduler.record(source: viewModel.behaviorRelayElements)
        scheduler.bind(events, to: viewModel.behaviorRelayInput)
        scheduler.start()
        XCTAssertEqual(source.events, [.next(0, "start")] + events)
    }

    func testSentNextEvent() {
        events = [.next(10, "alpha"), .completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).next()
        assert(source).next(at: 10)
        assert(source).next(times: 1)

        assert(source).next(at: 0, equal: "alpha")
    }

    func testSentNextEventPublishRelay() {
        events = [.next(10, "alpha")]
        let source = scheduler.record(source: viewModel.publishRelayElements)
        scheduler.bind(events, to: viewModel.publishRelayInput)
        scheduler.start()
        assert(source).next()
        assert(source).next(at: 10)
        assert(source).next(times: 1)

        assert(source).next(at: 0, equal: "alpha")
    }

    func testSentNextEventBehaviorRelay() {
        events = [.next(10, "alpha")]
        let source = scheduler.record(source: viewModel.behaviorRelayElements)
        scheduler.bind(events, to: viewModel.behaviorRelayInput)
        scheduler.start()
        assert(source).next()
        assert(source).next(at: 10)
        assert(source).next(times: 2)

        assert(source).next(at: 0, equal: "start")
        assert(source).next(at: 1, equal: "alpha")
    }

    func testNextEventsHelpers() {
        events = [.next(10, "alpha"), .next(12, "bravo"), .completed(15)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source) == "alpha"
        assert(source).firstNext(equal: "alpha")
        assert(source).lastNext(equal: "bravo")
    }

    func testNextEventsHelpersPublishRelay() {
        events = [.next(10, "alpha"), .next(12, "bravo")]
        let source = scheduler.record(source: viewModel.publishRelayElements)
        scheduler.bind(events, to: viewModel.publishRelayInput)
        scheduler.start()
        assert(source) == "alpha"
        assert(source).firstNext(equal: "alpha")
        assert(source).lastNext(equal: "bravo")
    }

    func testNextEventsHelpersBehaviorRelay() {
        events = [.next(10, "alpha"), .next(12, "bravo")]
        let source = scheduler.record(source: viewModel.behaviorRelayElements)
        scheduler.bind(events, to: viewModel.behaviorRelayInput)
        scheduler.start()
        assert(source) == "start"
        assert(source).firstNext(equal: "start")
        assert(source).lastNext(equal: "bravo")
    }

    func testNotSentNext() {
        events = [.completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).not.next()
    }

    func testNotSentNextPublishRelay() {
        events = [.completed(10)]
        let source = scheduler.record(source: viewModel.publishRelayElements)
        scheduler.bind(events, to: viewModel.publishRelayInput)
        scheduler.start()
        assert(source).not.next()
    }

    func testErrorEvent() {
        events = [.next(10, "alpha"), .error(20, TestError())]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).error()
        assert(source).error(at: 20)
        assert(source).error(after: 1)
        assert(source).error(with: TestError.self)
        assert(source).error(with: TestError())
    }

    func testNotErrorEvent() {
        events = [.next(10, "alpha"), .completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).not.error()
    }

    func testNotErrorEventPublishRelay() {
        events = [.next(10, "alpha")]
        let source = scheduler.record(source: viewModel.publishRelayElements)
        scheduler.bind(events, to: viewModel.publishRelayInput)
        scheduler.start()
        assert(source).not.error()
    }

    func testNotErrorEventBehaviorRelay() {
        events = [.next(10, "alpha")]
        let source = scheduler.record(source: viewModel.behaviorRelayElements)
        scheduler.bind(events, to: viewModel.behaviorRelayInput)
        scheduler.start()
        assert(source).not.error()
    }

    func testComplete() {
        events = [.next(10, "alpha"), .completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).complete()
        assert(source).complete(at: 10)
        assert(source).complete(after: 1)
    }

    func testNotComplete() {
        events = [.next(10, "alpha")]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).not.complete()
    }

    func testNotCompletePublishRelay() {
        events = [.next(10, "alpha")]
        let source = scheduler.record(source: viewModel.publishRelayElements)
        scheduler.bind(events, to: viewModel.publishRelayInput)
        scheduler.start()
        assert(source).not.complete()
    }

    func testNotCompleteBehaviorRelay() {
        events = [.next(10, "alpha")]
        let source = scheduler.record(source: viewModel.behaviorRelayElements)
        scheduler.bind(events, to: viewModel.behaviorRelayInput)
        scheduler.start()
        assert(source).not.complete()
    }

    func testNever() {
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind([], to: viewModel.input)
        scheduler.start()
        assert(source).never()
    }

    func testNeverPublishRelay() {
        let source = scheduler.record(source: viewModel.publishRelayElements)
        scheduler.bind([], to: viewModel.publishRelayInput)
        scheduler.start()
        assert(source).never()
    }

    func testEmpty() {
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind([.completed(10)], to: viewModel.input)
        scheduler.start()
        assert(source).empty()
    }

    func testJust() {
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind([.next(10, "alpha"), .completed(10)], to: viewModel.input)
        scheduler.start()
        assert(source).just("alpha")
    }

    func testMatchFirstNext() {
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind([.next(10, "alpha"), .completed(10)], to: viewModel.input)
        scheduler.start()
        assert(source).firstNext {
            (!($0?.isEmpty ?? false), "be empty")
        }
    }

    func testMatchFirstNextPublishRelay() {
        let source = scheduler.record(source: viewModel.publishRelayElements)
        scheduler.bind([.next(10, "alpha"), .completed(10)], to: viewModel.publishRelayInput)
        scheduler.start()
        assert(source).firstNext {
            (!($0?.isEmpty ?? false), "be empty")
        }
    }

    func testMatchFirstNextBehaviorRelay() {
        let source = scheduler.record(source: viewModel.behaviorRelayElements)
        scheduler.bind([.next(10, "alpha"), .completed(10)], to: viewModel.behaviorRelayInput)
        scheduler.start()
        assert(source).firstNext {
            (!($0?.isEmpty ?? false), "be empty")
        }
    }

    override func tearDown() {
        viewModel = nil
        scheduler = nil
        events = nil
        super.tearDown()
    }
}
