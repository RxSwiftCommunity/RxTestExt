import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class TestSchedulerExtTests: XCTestCase {
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
}
