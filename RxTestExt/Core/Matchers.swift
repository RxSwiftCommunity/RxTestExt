import RxSwift
import RxTest

func haveNext<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return !events.filter { $0.value.element != nil }.isEmpty
}

func haveError<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return !events.filter { $0.value.error != nil }.isEmpty
}

func haveCompleted<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return !events.filter { $0.value.isCompleted }.isEmpty
}
