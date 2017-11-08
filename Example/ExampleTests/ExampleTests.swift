import XCTest
import RxTest
import RxTestExt
@testable import Example

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

    override func tearDown() {
        super.tearDown()
    }
}
