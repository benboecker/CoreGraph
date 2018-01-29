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

	var frontier = Frontier<String>()
	var pathA = Path<String>.end
	var pathB = Path<String>.end
	var pathC = Path<String>.end
	var pathD = Path<String>.end
	var pathE = Path<String>.end
	var pathF = Path<String>.end

	override func setUp() {
		super.setUp()

		frontier = Frontier<String>()

		// pathA: (139) [A] - [B] - [E] - [F]
		// pathB: (67)  [A] - [B] - [D] - [F]
		// pathC: (99)  [A] - [B] - [D] - [E]
		// pathD: (102) [A] - [C] - [D]
		// pathE: (78)  [A] - [C] - [B]
		// pathF: (111) [A] - [C] - [E] - [F]

		pathA = pathA.append("A", weight: 100)
		pathA = pathA.append("B", weight: 30)
		pathA = pathA.append("E", weight: 5)
		pathA = pathA.append("F", weight: 4)

		pathB = pathB.append("A", weight: 50)
		pathB = pathB.append("B", weight: 10)
		pathB = pathB.append("D", weight: 5)
		pathB = pathB.append("F", weight: 2)

		pathC = pathC.append("A", weight: 50)
		pathC = pathC.append("B", weight: 40)
		pathC = pathC.append("D", weight: 5)
		pathC = pathC.append("E", weight: 4)

		pathD = pathD.append("A", weight: 50)
		pathD = pathD.append("C", weight: 50)
		pathD = pathD.append("D", weight: 2)

		pathE = pathE.append("A", weight: 50)
		pathE = pathE.append("C", weight: 20)
		pathE = pathE.append("B", weight: 8)

		pathF = pathF.append("A", weight: 50)
		pathF = pathF.append("C", weight: 50)
		pathF = pathF.append("E", weight: 10)
		pathF = pathF.append("F", weight: 1)

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

		XCTAssertEqual(frontier.paths.minimum, pathA)
	}

	func testRemovePath() {
		XCTAssertTrue(frontier.isEmpty)

		frontier.add(pathA)
		XCTAssertFalse(frontier.isEmpty)

		let resultA = frontier.removeBestPath()
		XCTAssertTrue(frontier.isEmpty)

		XCTAssertTrue(resultA.isExpected)
		let resultB = frontier.removeBestPath()
		XCTAssertTrue(resultB.isUnexpected)
		XCTAssertEqual(resultB.error!, GraphError.elementNotRemoved)
	}

	func testRemoveAllPaths() {
		frontier.add(pathA)
		frontier.add(pathB)
		frontier.add(pathC)
		frontier.add(pathD)
		frontier.add(pathE)
		frontier.add(pathF)
		XCTAssertFalse(frontier.isEmpty)
		frontier.removeAllPaths()
		XCTAssertTrue(frontier.isEmpty)
	}

	func testGetBestPath() {
		frontier.add(pathA)
		frontier.add(pathB)
		frontier.add(pathC)
		frontier.add(pathD)
		frontier.add(pathE)
		frontier.add(pathF)

		let bestPathResult = frontier.bestPath

		XCTAssertTrue(bestPathResult.isExpected)
		XCTAssertEqual(bestPathResult.data!, pathB)
	}

	func testGetBestPathUnexpected() {
		let bestPathResult = frontier.bestPath

		XCTAssertTrue(bestPathResult.isUnexpected)
		XCTAssertEqual(bestPathResult.error!, GraphError.frontierIsEmpty)
	}

}

