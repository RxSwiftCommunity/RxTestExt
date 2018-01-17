import RxSwift
import RxCocoa

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
