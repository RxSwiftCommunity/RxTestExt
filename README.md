# RxTestExt
[![CircleCI](https://circleci.com/gh/RxSwiftCommunity/RxTestExt.png)](https://circleci.com/gh/RxSwiftCommunity/RxTestExt/tree/master)
![pod](https://img.shields.io/cocoapods/v/RxTestExt.svg)

A collection of operators &amp; tools not found in the core RxTest distribution.

# Usage
`RxTestExt` can be used for common unit testing tasks like,
- recording events from an observable into a `Testable Observer`
- binding an array of recorded events (timeline) to an observer.
- assert that recorded events match specific criteria.

For example:
```
func testSomething() {
   let source = scheduler.record(source: someObservable)
   scheduler.bind([next(10, "alpha"), completed(10)],
                  to: someObserver)
   scheduler.start()
   assert(source).next()
   assert(source).not.error()
}
```

# Features
- Scheduler subscription extensions
   - record observable events into a `TestableObserver`
   - bind recorded events to an observer
- Rx Timeline matchers functions
   - assert `TestableObserver` recorded `next` events.
   - assert `TestableObserver` received `error` events.
   - assert `TestableObserver` received `complete` events.
