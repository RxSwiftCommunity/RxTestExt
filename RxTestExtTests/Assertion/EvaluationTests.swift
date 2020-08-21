import XCTest
@testable import RxTestExt

class EvaluationTests: XCTestCase {
    var sut: Evaluation!
    var failureMessage: String!
    
    override func setUp() {
        super.setUp()
        Evaluation.assertionHandler = { msg, _, _ in
            self.failureMessage = msg
        }
    }
    
    func test_success_notFail() {
        sut = .success("")
        sut.verify(negated: false)
        XCTAssertNil(failureMessage)
    }
    
    func test_failure_formatsMessage() {
        sut = .failure(expected: "be true", actual: false)
        sut.verify(negated: false)
        XCTAssertEqual(failureMessage, "expected be true, got false")
    }
    func test_failure_customMessage() {
        sut = .customFailure(message: "some-random-failure")
        sut.verify(negated: false)
        XCTAssertEqual(failureMessage, "some-random-failure")
    }
}

class EvaluationNegatedTests: XCTestCase {
    var sut: Evaluation!
    var failureMessage: String!
    
    override func setUp() {
        super.setUp()
        Evaluation.assertionHandler = { msg, _, _ in
            self.failureMessage = msg
        }
    }
    
    func test_success_notFail() {
        sut = .success("pass")
        sut.verify(negated: true)
        XCTAssertEqual(failureMessage, "expected not to pass")
    }
    
    func test_failure_formatsMessage() {
        sut = .failure(expected: "be true", actual: false)
        sut.verify(negated: true)
        XCTAssertEqual(failureMessage, nil)
    }
    func test_failure_customMessage() {
        sut = .customFailure(message: "some-random-failure")
        sut.verify(negated: true)
        XCTAssertEqual(failureMessage, nil)
    }
}
