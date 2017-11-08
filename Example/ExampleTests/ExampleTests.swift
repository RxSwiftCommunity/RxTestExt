import XCTest
import RxTest
import RxTestExt
@testable import Example

struct TestError: Swift.Error {
    let message: String
    init(_ message: String = "") {
        self.message = message
    }
}
class ExampleTests: XCTestCase {

    var viewModel: ViewModel!
    var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        viewModel = ViewModel()
        scheduler = TestScheduler(initialClock: 0)
    }

    func testRecordingAllEvents() {
        let events = [next(10, "alpha"), completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        XCTAssertEqual(source.events, events)
    }

    func testSentNextEvent() {
        let events = [next(10, "alpha"), completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        AssertSentNext(source)
    }

    func testErrorEvent() {
        let events = [next(10, "alpha"), error(20, TestError())]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        AssertError(source)
    }

    func testComplete() {
        let events = [next(10, "alpha"), completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        AssertComplete(source)
    }

    override func tearDown() {
        viewModel = nil
        scheduler = nil
        super.tearDown()
    }
}
