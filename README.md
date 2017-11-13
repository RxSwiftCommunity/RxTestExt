# RxTestExt
A collection of operators &amp; tools not found in the core RxTest distribution.

# Installation
RxTestExt requires Swift 4 and RxSwift 4.0 or later. It can be installed using CocoaPods and is organized into the following subspecs;
1. Core (default)
Contains extensions of `RxTest` types to add extra functionalities such as recording events on `TestableObserver`.
2. XCTest
Contains XCAssert functions to assert conditions of `TestableObserver`'s recorded timeline. It should be used on XCTests .
3. Nimble
Custom `Nimble` predicate matchers for `TestableObserver`.

# Usage
## XCTest
```
func testSomething() {
   let source = scheduler.record(source: someObservable)
   scheduler.bind([next(10, "alpha"), completed(10)],
                  to: someObserver)
   scheduler.start()
   AssertSentNext(source)
   AssertComplete(source)
}
```
## Nimble
```
it("complete") {
   let events = [next(10, "alpha"), completed(10)]
   let source = scheduler.record(source: someObservable)
   scheduler.bind(events, to: someObserver)
   scheduler.start()
   expect(source).to(complete())
}
```

# Features
- Scheduler subscription extensions
   - record observable events into a `TestableObserver`
   - bind recorded events to an observer
- XCAssert helper functions
   - assert `TestableObserver` recorded any next events.
   - assert `TestableObserver` received any error events.
   - assert `TestableObserver` eventually completed.
- Nimble predicate matchers
   - match if `TestableObserver` recorded any next events.
   - match if `TestableObserver` received any error events.
   - match if `TestableObserver` eventually completed.