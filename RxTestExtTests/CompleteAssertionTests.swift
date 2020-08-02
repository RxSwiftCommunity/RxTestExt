import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class CompleteAssertionTests: XCTestCase {

    var viewModel: ViewModel!
    var scheduler: TestScheduler!
    var events: [Recorded<Event<String>>]!
    override func setUp() {
        super.setUp()
        viewModel = ViewModel()
        scheduler = TestScheduler(initialClock: 0)
        events = []
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
}
