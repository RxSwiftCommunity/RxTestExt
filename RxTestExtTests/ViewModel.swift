import Foundation
import XCTest
import RxSwift
import RxRelay
import RxTest
@testable import RxTestExt

/// A dummy view model for testing
class ViewModel {
    private let _subject = PublishSubject<String>()

    var elements: Observable<String> {
        return _subject.asObservable()
    }

    var publishRelayElements: Observable<String> {
        return publishRelayInput.asObservable()
    }

    var behaviorRelayElements: Observable<String> {
        return behaviorRelayInput.asObservable()
    }

    var input: AnyObserver<String> {
        return _subject.asObserver()
    }

    var publishRelayInput = PublishRelay<String>()
    var behaviorRelayInput = BehaviorRelay<String>(value: "start")
}

extension TestScheduler {
    func bind<T>(_ observable: Observable<T>, to observer: TestableObserver<T>) {
        let disposable = observable.subscribe(observer)
        scheduleAt(10_000) {
            disposable.dispose()
        }
    }
}

func failWithMessage(_ message: String,
                     file: StaticString = #filePath,
                     line: UInt = #line,
                     closure: () -> Void) {
    let handler = Evaluation.assertionHandler
    var failureMessage: String?
    Evaluation.assertionHandler = { msg, _, _ in failureMessage = msg }
    closure()
    Evaluation.assertionHandler = handler
    
    guard let failure = failureMessage else {
        XCTFail("did not fail", file: file, line: line)
        return
    }
    
    XCTAssertEqual(failure, message, file: file, line: line)
}
