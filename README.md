# RxTestExt
A collection of operators &amp; tools not found in the core RxTest distribution.

# Usage
## XCTest
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
   - assert `TestableObserver` recorded any next events.
   - assert `TestableObserver` received any error events.
   - assert `TestableObserver` eventually completed.
