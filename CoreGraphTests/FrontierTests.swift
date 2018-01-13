//
//  FrontierTests.swift
//  CoreGraphTests
//
//  Created by Benni on 12.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation
import XCTest
@testable import CoreGraph

class FrontierTests: XCTestCase {

	var frontier: Frontier<Int>!
	var pathA: Frontier<Int>.Path<Int>!
	var pathB: Frontier<Int>.Path<Int>!

	
	override func setUp() {
		super.setUp()
		
		self.frontier = Frontier<Int>()
		
		let nodeA = Node(with: 23)
		let nodeB = Node(with: 38)
		let nodeC = Node(with: 42)
		let nodeD = Node(with: 50)
		
		let _pathA = Frontier<Int>.Path<Int>(destination: nodeA)
		let _pathB = Frontier<Int>.Path<Int>(destination: nodeB)
		let _pathC = Frontier<Int>.Path<Int>(destination: nodeC)
		let _pathD = Frontier<Int>.Path<Int>(destination: nodeD)

		_pathB.previous = _pathA
		_pathC.previous = _pathB
		_pathD.previous = _pathA
		pathA = _pathC
		pathA.total = 139
		
		pathB = _pathD
		pathB.total = 67
	}
	
	func testIsEmpty() {
		XCTAssertTrue(frontier.isEmpty)
	}
	
	func testIsNotEmpty() {
		frontier.add(pathA)
		XCTAssertFalse(frontier.isEmpty)
	}
	
	func testAddPath() {
		frontier.add(pathA)
		
		XCTAssertEqual(frontier.paths.first!, pathA)
	}
	
	func testRemovePath() {
		XCTAssertTrue(frontier.isEmpty)
	
		frontier.add(pathA)
		XCTAssertFalse(frontier.isEmpty)

		let resultA = frontier.remove(pathA)
		XCTAssertTrue(frontier.isEmpty)
		
		XCTAssertTrue(resultA.isExpected)
		let resultB = frontier.remove(pathA)
		XCTAssertTrue(resultB.isUnexpected)
		XCTAssertEqual(resultB.error!, GraphError.elementNotRemoved)
	}
	
	func testRemoveAllPaths() {
		frontier.add(pathA)
		frontier.add(pathB)
		XCTAssertFalse(frontier.isEmpty)
		frontier.removeAllPaths()
		XCTAssertTrue(frontier.isEmpty)
	}
	
	func testGetBestPath() {
		frontier.add(pathA)
		frontier.add(pathB)

		let bestPathResult = frontier.getBestPath()
		
		XCTAssertTrue(bestPathResult.isExpected)
		XCTAssertEqual(bestPathResult.data!, pathB)
		
	}
}













