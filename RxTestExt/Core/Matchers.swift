import RxSwift
import RxTest

func haveNext<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return events.first?.value.element != nil
}

func haveError<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return events.last?.value.error != nil
}

func haveCompleted<T>(_ events: [Recorded<Event<T>>]) -> Bool {
    return events.last?.value.isCompleted ?? false
}
