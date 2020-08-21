# RxTestExt
![pod](https://img.shields.io/cocoapods/v/RxTestExt.svg)

A collection of operators &amp; tools not found in the core RxTest distribution.

# Usage
`RxTestExt` can be used for common unit testing tasks like,
- recording events from an observable into a `Testable Observer`
- binding an array of recorded events (timeline) to an Observer or a Relay.
- assert that recorded events match specific criteria.

For example:
```swift
func testSomething() {
   let source = scheduler.record(source: someObservable)
   scheduler.bind([next(10, "alpha"), completed(10)],
                  to: someObserver)
   scheduler.start()
   then(source).should.next(at: 10)
   then(source).shouldNot.error()
}
```

# Features
- Scheduler subscription extensions
   - record observable events into a `TestableObserver`.
   - bind recorded events to an Observer or a Relay.
- Rx Timeline expectations
   - assert `TestableObserver` recorded some specific next events.
   - assert `TestableObserver` received some specific complete event.
   - assert `TestableObserver` received some specific error event.
   - assert `TestableObserver` recorded events matching a timeline from one of Rx operators
   
- Rx Timeline matchers functions [DEPRECATED]
   - assert `TestableObserver` recorded `next` events.
   - assert `TestableObserver` received `error` events.
   - assert `TestableObserver` received `complete` events.
