////
////  FrontierTests.swift
////  CoreGraphTests
////
////  Created by Benni on 12.01.18.
////  Copyright © 2018 Ben Boecker. All rights reserved.
////
//
//import Foundation
//import XCTest
//@testable import CoreGraph
//
//class FrontierTests: XCTestCase {
//
//	var frontier: Frontier<String>!
//	var pathA: Frontier<String>.Path<String>!
//	var pathB: Frontier<String>.Path<String>!
//	var pathC: Frontier<String>.Path<String>!
//	var pathD: Frontier<String>.Path<String>!
//	var pathE: Frontier<String>.Path<String>!
//	var pathF: Frontier<String>.Path<String>!
//
//
//	override func setUp() {
//		super.setUp()
//
//		self.frontier = Frontier<String>()
//
//		let nodeA = Node(with: "A")
//		let nodeB = Node(with: "B")
//		let nodeC = Node(with: "C")
//		let nodeD = Node(with: "D")
//		let nodeE = Node(with: "E")
//		let nodeF = Node(with: "F")
//
//		// pathA: (139) [A] - [B] - [E] - [F]
//		// pathB: (67)  [A] - [B] - [D] - [F]
//		// pathC: (99)  [A] - [B] - [D] - [E]
//		// pathD: (102) [A] - [C] - [D]
//		// pathE: (78)  [A] - [C] - [B]
//		// pathF: (111) [A] - [C] - [E] - [F]
//
//		pathA = Frontier<String>.Path<String>(destination: nodeA)
//		pathA.previous = Frontier<String>.Path<String>(destination: nodeB)
//		pathA.previous?.previous = Frontier<String>.Path<String>(destination: nodeE)
//		pathA.previous?.previous?.previous = Frontier<String>.Path<String>(destination: nodeF)
//		pathA.total = 139
//
//		pathB = Frontier<String>.Path<String>(destination: nodeA)
//		pathB.previous = Frontier<String>.Path<String>(destination: nodeB)
//		pathB.previous?.previous = Frontier<String>.Path<String>(destination: nodeD)
//		pathB.previous?.previous?.previous = Frontier<String>.Path<String>(destination: nodeF)
//		pathB.total = 67
//
//		pathC = Frontier<String>.Path<String>(destination: nodeA)
//		pathC.previous = Frontier<String>.Path<String>(destination: nodeB)
//		pathC.previous?.previous = Frontier<String>.Path<String>(destination: nodeD)
//		pathC.previous?.previous?.previous = Frontier<String>.Path<String>(destination: nodeE)
//		pathC.total = 99
//
//		pathD = Frontier<String>.Path<String>(destination: nodeA)
//		pathD.previous = Frontier<String>.Path<String>(destination: nodeC)
//		pathD.previous?.previous = Frontier<String>.Path<String>(destination: nodeD)
//		pathD.total = 102
//
//		pathE = Frontier<String>.Path<String>(destination: nodeA)
//		pathE.previous = Frontier<String>.Path<String>(destination: nodeC)
//		pathE.previous?.previous = Frontier<String>.Path<String>(destination: nodeB)
//		pathE.total = 78
//
//		pathF = Frontier<String>.Path<String>(destination: nodeA)
//		pathF.previous = Frontier<String>.Path<String>(destination: nodeC)
//		pathF.previous?.previous = Frontier<String>.Path<String>(destination: nodeE)
//		pathF.previous?.previous?.previous = Frontier<String>.Path<String>(destination: nodeF)
//		pathF.total = 111
//	}
//
//	func testIsEmpty() {
//		XCTAssertTrue(frontier.isEmpty)
//	}
//
//	func testIsNotEmpty() {
//		frontier.add(pathA)
//		XCTAssertFalse(frontier.isEmpty)
//	}
//
//	func testAddPath() {
//		frontier.add(pathA)
//
//		XCTAssertEqual(frontier.paths.peek()!, pathA)
//	}
//
//	func testRemovePath() {
//		XCTAssertTrue(frontier.isEmpty)
//
//		frontier.add(pathA)
//		XCTAssertFalse(frontier.isEmpty)
//
//		let resultA = frontier.removeBestPath()
//		XCTAssertTrue(frontier.isEmpty)
//
//		XCTAssertTrue(resultA.isExpected)
//		let resultB = frontier.removeBestPath()
//		XCTAssertTrue(resultB.isUnexpected)
//		XCTAssertEqual(resultB.error!, GraphError.elementNotRemoved)
//	}
//
//	func testRemoveAllPaths() {
//		frontier.add(pathA)
//		frontier.add(pathB)
//		frontier.add(pathC)
//		frontier.add(pathD)
//		frontier.add(pathE)
//		frontier.add(pathF)
//		XCTAssertFalse(frontier.isEmpty)
//		frontier.removeAllPaths()
//		XCTAssertTrue(frontier.isEmpty)
//	}
//
//	func testGetBestPath() {
//		frontier.add(pathA)
//		frontier.add(pathB)
//		frontier.add(pathC)
//		frontier.add(pathD)
//		frontier.add(pathE)
//		frontier.add(pathF)
//
//		let bestPathResult = frontier.getBestPath()
//
//		XCTAssertTrue(bestPathResult.isExpected)
//		XCTAssertEqual(bestPathResult.data!, pathB)
//	}
//
//	func testGetBestPathUnexpected() {
//		let bestPathResult = frontier.getBestPath()
//
//		XCTAssertTrue(bestPathResult.isUnexpected)
//		XCTAssertEqual(bestPathResult.error!, GraphError.frontierIsEmpty)
//	}
//
//}

