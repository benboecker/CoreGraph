//
//  MinimumFirstArrayTests.swift
//  CoreGraphTests
//
//  Created by Benni on 22.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation
import XCTest
@testable import CoreGraph

class MinHeapTests: XCTestCase {
	func testInsert() {
		var minimumArray = MinHeap<Int>()

		minimumArray.add(5)
		minimumArray.add(3)
		minimumArray.add(8)
		minimumArray.add(4)
		minimumArray.add(6)

		XCTAssertEqual(minimumArray[0], 3)
		XCTAssertEqual(minimumArray[1], 4)
		XCTAssertEqual(minimumArray[2], 8)
		XCTAssertEqual(minimumArray[3], 5)
		XCTAssertEqual(minimumArray[4], 6)
	}
	
	func testInsert2() {
		var minHeap: MinHeap<Int> = [1, 3, 6, 5, 9, 8]
		
		minHeap.add(-2)
		

		XCTAssertEqual(minHeap[0], -2)
		XCTAssertEqual(minHeap[1], 3)
		XCTAssertEqual(minHeap[2], 1)
		XCTAssertEqual(minHeap[3], 5)
		XCTAssertEqual(minHeap[4], 9)
		XCTAssertEqual(minHeap[5], 8)
		XCTAssertEqual(minHeap[6], 6)
	}
	
	func testMinimumRemove() {
		var minimumArray: MinHeap<Int> = [5, 3, 8, 4, 6]
		
		XCTAssertEqual(minimumArray[0], 3)
		XCTAssertEqual(minimumArray[1], 4)
		XCTAssertEqual(minimumArray[2], 8)
		XCTAssertEqual(minimumArray[3], 5)
		XCTAssertEqual(minimumArray[4], 6)
		
		minimumArray.remove()
		
		XCTAssertEqual(minimumArray[0], 4)
		XCTAssertEqual(minimumArray[1], 5)
		XCTAssertEqual(minimumArray[2], 8)
		XCTAssertEqual(minimumArray[3], 6)
	}
}
