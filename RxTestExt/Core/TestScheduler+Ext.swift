import RxSwift
import RxTest

extension TestScheduler {

    /// Builds testable observer for s specific observable sequence, binds it's results and sets up disposal.
    ///
    //  This function was copied from RxSwift's example app:
    //  https://github.com/ReactiveX/RxSwift/blob/f639ff450487340a18931a7dbe3d5c8a0976be7b/RxExample/RxExample-iOSTests/TestScheduler%2BMarbleTests.swift#L189
    //
    /// - Parameter source: Observable sequence to observe.
    /// - Returns: Observer that records all events for observable sequence.
    public func record<O: ObservableConvertibleType>(source: O) -> TestableObserver<O.Element> {
        let observer = self.createObserver(O.Element.self)
        let disposable = source.asObservable().subscribe(observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }

    /// Binds given events to an observer
    ///
    /// Builds a hot observable with predefined events, binds it's result to given observer and sets up disposal.
    ///
    /// - Parameters:
    ///   - events: Array of recorded events to emit over the scheduled observable
    ///   - target: Observer to bind to
    public func bind<O: ObserverType>(_ events: [Recorded<Event<O.Element>>], to target: O) {
        let driver = self.createHotObservable(events)
        let disposable = driver.asObservable().subscribe(target)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
    }
}
