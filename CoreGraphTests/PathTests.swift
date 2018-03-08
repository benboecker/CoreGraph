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
	
	var path: Path<Int>!
	
	override func setUp() {
		super.setUp()
		
		path = Path(with: 1, weight: 0.0)
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
		XCTAssertEqual(String(describing: path!), "[1] —5.0— [2] —20.0— [3] —15.0— [4] —25.0— [5]")
	}
	
	func testEquality() {
		let pathA = Path(with: 25, weight: 65)
		let pathB = Path(with: 25, weight: 65)
		let pathC = Path(with: 25, weight: 165)
		let pathD = Path(with: 12, weight: 65)

		XCTAssertTrue(pathA == pathB)
		XCTAssertTrue(pathA == pathA)
		XCTAssertTrue(pathA == pathC)
		XCTAssertFalse(pathA == pathD)
		XCTAssertFalse(pathC == pathD)
	}
	
	func testComparable() {
		let pathCopy = Path(with: 25, weight: 66)
		let secondPath = Path(with: 25, weight: 64)
		let thirdPath = Path(with: 12, weight: 77)
		
		XCTAssertTrue(path < pathCopy)
		XCTAssertFalse(path < secondPath)
		XCTAssertTrue(path < thirdPath)
	}
}




