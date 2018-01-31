//
//  FrontierPathTests.swift
//  CoreGraphTests
//
//  Created by Benni on 12.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation
import XCTest
@testable import CoreGraph

class PathTests: XCTestCase {
	
	var path = Path<Int>.end
	
	override func setUp() {
		super.setUp()
		
		path = path.append(1, weight: 0)
		path = path.append(2, weight: 5)
		path = path.append(3, weight: 20)
		path = path.append(4, weight: 15)
		path = path.append(5, weight: 25)
	}

	func testHasNode() {
		XCTAssertTrue(path.contains(1))
		XCTAssertTrue(path.contains(4))
		XCTAssertFalse(path.contains(128))
	}
	
	func testGetNode() {
		XCTAssertEqual(path.node, 5)
		XCTAssertNotEqual(path.node, 28)
		XCTAssertEqual(Path<Int>.end.node, nil)
	}
	
	func testGetNodeValues() {
		let nodes = path.nodeData
		let expected: [(Int, Double)]
		expected = [
			(1, 0.0),
			(2, 5.0),
			(3, 20.0),
			(4, 15.0),
			(5, 25.0),
		]
		
		XCTAssertEqual(nodes.map{ $0.0 }, expected.map{ $0.0 })
		XCTAssertEqual(nodes.map{ $0.1 }, expected.map{ $0.1 })
	}
	
	func testTotalWeight() {
		XCTAssertEqual(path.totalWeight, 65.0)
	}
	
	func testGetDescription() {
		XCTAssertEqual("\(path)", "[1] —5.0— [2] —20.0— [3] —15.0— [4] —25.0— [5]")
	}
	
	func testEquality() {
		let pathA = Path.end.append(25, weight: 65)
		let pathB = Path.end.append(25, weight: 65)
		let pathC = Path.end.append(25, weight: 165)
		let pathD = Path.end.append(12, weight: 65)

		XCTAssertTrue(pathA == pathB)
		XCTAssertTrue(pathA == pathA)
		XCTAssertTrue(pathA == pathC)
		XCTAssertFalse(pathA == pathD)
		XCTAssertFalse(pathC == pathD)
	}
	
	func testComparable() {
		let pathCopy = Path.end.append(25, weight: 66)
		let secondPath = Path.end.append(25, weight: 64)
		let thirdPath = Path.end.append(12, weight: 77)
		
		XCTAssertTrue(path < pathCopy)
		XCTAssertFalse(path < secondPath)
		XCTAssertTrue(path < thirdPath)
	}
}




