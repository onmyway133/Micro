import XCTest

import MicroTests

var tests = [XCTestCaseEntry]()
tests += MicroTests.allTests()
XCTMain(tests)
