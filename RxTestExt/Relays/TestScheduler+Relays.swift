import RxSwift
import RxRelay
import RxTest

extension TestScheduler {
    /// Binds given events to a PublishRelay
    ///
    /// Builds a hot observable with predefined events, binds it's result to given PublishRelay and sets up disposal.
    ///
    /// - Parameters:
    ///   - events: Array of recorded events to emit over the scheduled observable
    ///   - relay: Publish Relay to bind to
    public func bind<E>(_ events: [Recorded<Event<E>>], to relay: PublishRelay<E>) {
        let driver = self.createHotObservable(events)
        let disposable = driver.bind(to: relay)

        self.scheduleAt(100000) {
            disposable.dispose()
        }
    }

    /// Binds given events to a BehaviorRelay
    ///
    /// Builds a hot observable with predefined events, binds it's result to given BehaviorRelay and sets up disposal.
    ///
    /// - Parameters:
    ///   - events: Array of recorded events to emit over the scheduled observable
    ///   - relay: Behavior Relay to bind to
    public func bind<E>(_ events: [Recorded<Event<E>>], to relay: BehaviorRelay<E>) {
        let driver = self.createHotObservable(events)
        let disposable = driver.bind(to: relay)

        self.scheduleAt(100000) {
            disposable.dispose()
        }
    }
}
