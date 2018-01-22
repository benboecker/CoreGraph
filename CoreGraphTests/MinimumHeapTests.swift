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

class MinimumHeapTests: XCTestCase {
	func testCreateHeap() {
		var minimumArray = MinimumHeap<Int>()

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
	
	func testMinimumRemove() {
		var minimumArray: MinimumHeap<Int> = [5, 3, 8, 4, 6]
		
		XCTAssertEqual(minimumArray[0], 3)
		XCTAssertEqual(minimumArray[1], 4)
		XCTAssertEqual(minimumArray[2], 8)
		XCTAssertEqual(minimumArray[3], 5)
		XCTAssertEqual(minimumArray[4], 6)
		
		minimumArray.removeFirst()
		
		XCTAssertEqual(minimumArray[0], 4)
		XCTAssertEqual(minimumArray[1], 5)
		XCTAssertEqual(minimumArray[2], 8)
		XCTAssertEqual(minimumArray[3], 6)
	}
}
