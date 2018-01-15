//
//  ResultTests.swift
//  CoreGraphTests
//
//  Created by Benni on 12.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation
import XCTest
@testable import CoreGraph


class ResultTests: XCTestCase {

	func testExpectedResult() {
		let result = Result.expected("Test")
		
		XCTAssertTrue(result.isExpected)
		XCTAssertFalse(result.isUnexpected)
	
		result.onExpected { (string) in
			XCTAssertEqual(string, "Test")
		}
		result.onUnexpected { (_) in
			XCTFail()
		}
		
		XCTAssertNotNil(result.data)
		XCTAssertNil(result.error)
		XCTAssertEqual(result.data!, "Test")
	}
	
	func testUnexpectedResult() {
		let result = Result<Any>.unexpected(.frontierIsEmpty)
		
		XCTAssertTrue(result.isUnexpected)
		XCTAssertFalse(result.isExpected)
		
		result.onUnexpected { (error) in
			XCTAssertEqual(error, GraphError.frontierIsEmpty)
		}
		result.onExpected { _ in
			XCTFail()
		}
		
		XCTAssertNotNil(result.error)
		XCTAssertNil(result.data)
		XCTAssertEqual(result.error!, GraphError.frontierIsEmpty)
	}
}
