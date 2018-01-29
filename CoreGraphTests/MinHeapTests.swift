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
		var minHeap = MinHeap<Int>()

		minHeap.add(5)
		minHeap.add(3)
		minHeap.add(8)
		minHeap.add(4)
		minHeap.add(6)

		XCTAssertEqual(minHeap[0], 3)
		XCTAssertEqual(minHeap[1], 4)
		XCTAssertEqual(minHeap[2], 8)
		XCTAssertEqual(minHeap[3], 5)
		XCTAssertEqual(minHeap[4], 6)
	}
	
	func testInsertFromArray() {
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
	
	func testRemove() {
		
		var minHeap = MinHeap<Int>()
		XCTAssertNil(minHeap.remove())

		minHeap = [5, 3, 8, 4, 6]
		
		XCTAssertEqual(minHeap[0], 3)
		XCTAssertEqual(minHeap[1], 4)
		XCTAssertEqual(minHeap[2], 8)
		XCTAssertEqual(minHeap[3], 5)
		XCTAssertEqual(minHeap[4], 6)
		
		minHeap.remove()
		
		XCTAssertEqual(minHeap[0], 4)
		XCTAssertEqual(minHeap[1], 5)
		XCTAssertEqual(minHeap[2], 8)
		XCTAssertEqual(minHeap[3], 6)
	}
}
