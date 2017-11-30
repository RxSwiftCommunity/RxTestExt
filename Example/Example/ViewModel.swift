import RxSwift

class ViewModel {
    private let _subject = PublishSubject<String>()

    var elements: Observable<String> {
        return _subject.asObservable()
    }

    var input: AnyObserver<String> {
        return _subject.asObserver()
    }
}
