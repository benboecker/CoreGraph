//
//  ArrayTests.swift
//  CoreGraphTests
//
//  Created by Benni on 12.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation
import XCTest
@testable import CoreGraph


class ArrayTests: XCTestCase {
	
	func testSafeSubscript() {
		let array = [1, 2, 3]
		let safeInt = array[safe: 1]
		let safeIntNil = array[safe: 128]
		
		XCTAssertNotNil(safeInt)
		XCTAssertEqual(safeInt!, 2)
		XCTAssertNil(safeIntNil)
	}
	
	func testGetElementAfter() {
		let array = ["A", "B", "C", "D"]
		
		let afterC = array.element(after: "C")
		let afterD = array.element(after: "D")
		let afterNotInArray = array.element(after: "NotInArray")

		XCTAssertNotNil(afterC)
		XCTAssertEqual(afterC!, "D")
		XCTAssertNil(afterD)
		XCTAssertNil(afterNotInArray)
	}
	
	
	func testGetElementBefore() {
		let array = ["A", "B", "C", "D"]
		
		let beforeC = array.element(before: "C")
		let beforeA = array.element(before: "A")
		let beforeNotInArray = array.element(before: "NotInArray")

		XCTAssertNotNil(beforeC)
		XCTAssertEqual(beforeC!, "B")
		XCTAssertNil(beforeA)
		XCTAssertNil(beforeNotInArray)
	}
	
	func testIndexWhere() {
		let array = ["A", "B", "C", "D"]
		
		let index = array.index { (element) -> (Bool) in
			return element == "B"
		}
		
		let indexNil = array.index { (element) -> (Bool) in
			return element == "Not in array"
		}
		
		XCTAssertNotNil(index)
		XCTAssertEqual(index!, 1)
		XCTAssertNil(indexNil)
		
	}
	
	func testRemoveObject() {
		var array = ["A", "B", "C", "D"]
		
		let removeResultExpected = array.remove(object: "B")
		let removeResultUnexpected = array.remove(object: "Not in array")
		
		XCTAssertTrue(removeResultExpected.isExpected)
		XCTAssertTrue(removeResultUnexpected.isUnexpected)
		XCTAssertEqual(removeResultExpected.data!, 1)
	}
	
	func testInsertSorted() {
		var array = [3, 8]
		
		array.addSorted(4)
		XCTAssertEqual(array, [3, 4, 8])

		array.addSorted(7)
		XCTAssertEqual(array, [3, 4, 7, 8])

		array.addSorted(14)
		XCTAssertEqual(array, [3, 4, 7, 8, 14])

		array.addSorted(1)
		XCTAssertEqual(array, [1, 3, 4, 7, 8, 14])

		
	}
}







