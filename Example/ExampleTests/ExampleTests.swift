import XCTest
import RxSwift
import RxTest
import RxTestExt
@testable import Example

struct TestError: Swift.Error, Equatable, CustomDebugStringConvertible {
    let message: String
    init(_ message: String = "") {
        self.message = message
    }
    public static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.message == rhs.message
    }

    var debugDescription: String {
        return "Error(\(message))"
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
        assert(source).next()
        assert(source).next(at: 10)
        assert(source).next(times: 1)

        assert(source).next(at: 0, equal: "alpha")
    }

    func testNextEventsHelpers() {
        let events = [next(10, "alpha"), next(12, "bravo"), completed(15)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source) == "alpha"
        assert(source).firstNext(equal: "alpha")
        assert(source).lastNext(equal: "bravo")
    }
    func testNotSentNext() {
        let events: [Recorded<Event<String>>] = [completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).not.next()
    }

    func testErrorEvent() {
        let events = [next(10, "alpha"), error(20, TestError())]
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
        let events = [next(10, "alpha"), completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).not.error()
    }

    func testComplete() {
        let events = [next(10, "alpha"), completed(10)]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).complete()
        assert(source).complete(at: 10)
        assert(source).complete(after: 1)
    }

    func testNotComplete() {
        let events = [next(10, "alpha")]
        let source = scheduler.record(source: viewModel.elements)
        scheduler.bind(events, to: viewModel.input)
        scheduler.start()
        assert(source).not.complete()
    }

    override func tearDown() {
        viewModel = nil
        scheduler = nil
        super.tearDown()
    }
}
