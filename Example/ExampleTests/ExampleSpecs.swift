import Quick
import Nimble
import RxTest
import RxTestExt
@testable import Example

class ExampleSpecs: QuickSpec {
    override func spec() {
        var viewModel: ViewModel!
        var scheduler: TestScheduler!

        beforeEach {
            viewModel = ViewModel()
            scheduler = TestScheduler(initialClock: 0)
        }

        afterEach {
            viewModel = nil
            scheduler = nil
        }

        it("send next events") {
            let events = [next(10, "alpha"), completed(10)]
            let source = scheduler.record(source: viewModel.elements)
            scheduler.bind(events, to: viewModel.input)
            scheduler.start()
            expect(source).to(sendNext())
        }

        it("error") {
            let events = [next(10, "alpha"), error(20, TestError())]
            let source = scheduler.record(source: viewModel.elements)
            scheduler.bind(events, to: viewModel.input)
            scheduler.start()
            expect(source).to(error())
        }

        it("complete") {
            let events = [next(10, "alpha"), completed(10)]
            let source = scheduler.record(source: viewModel.elements)
            scheduler.bind(events, to: viewModel.input)
            scheduler.start()
            expect(source).to(complete())
        }
    }
}
