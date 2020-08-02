import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class ErrorAssertionTests: XCTestCase {
    
    var viewModel: ViewModel!
    var scheduler: TestScheduler!
    var events: [Recorded<Event<String>>]!
    
    override func setUp() {
        super.setUp()
        viewModel = ViewModel()
        scheduler = TestScheduler(initialClock: 0)
        events = []
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
}
