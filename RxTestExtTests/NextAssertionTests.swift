import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class NextAssertionTests: XCTestCase {
    var viewModel: ViewModel!
    var scheduler: TestScheduler!
    var events: [Recorded<Event<String>>]!
    override func setUp() {
        super.setUp()
        viewModel = ViewModel()
        scheduler = TestScheduler(initialClock: 0)
        events = []
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

    func testNextEventsHelpers() {
        events = [.next(10, "alpha"), .next(12, "bravo"), .completed(15)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source) == "alpha"
        assert(source).firstNext(equal: "alpha")
        assert(source).lastNext(equal: "bravo")
    }

    func testNotSentNext() {
        events = [.completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).not.next()
    }

}
