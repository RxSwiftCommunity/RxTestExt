import Foundation
import XCTest
import RxSwift
import RxTest
@testable import RxTestExt

class OperatorAssertionTests: XCTestCase {

    var viewModel: ViewModel!
    var scheduler: TestScheduler!
    var events: [Recorded<Event<String>>]!
    override func setUp() {
        super.setUp()
        viewModel = ViewModel()
        scheduler = TestScheduler(initialClock: 0)
        events = []
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
