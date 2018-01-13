//
//  NodeTests.swift
//  UniMaps
//
//  Created by Benni on 14.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import XCTest
@testable import CoreGraph


class NodeTests: XCTestCase {
	
	func testEquality() {
		let nodeA = Node(with: 23)
		let nodeB = Node(with: 23)
		let nodeC = Node(with: 42)
		
		XCTAssertTrue(nodeA == nodeB)
		XCTAssertTrue(nodeA != nodeC)
	}
	
	func testHasEdge() {
		let nodeA = Node(with: 2)
		let nodeB = Node(with: 3)
		let nodeC = Node(with: 4)
		
		nodeA.addEdge(to: nodeB, weight: 2)
		nodeA.addEdge(to: nodeC, weight: 3)
		
		XCTAssertTrue(nodeA.hasEdge(to: nodeB))
		XCTAssertTrue(nodeA.hasEdge(to: nodeC))
		XCTAssertFalse(nodeB.hasEdge(to: nodeC))
	}
	
	func testAddEdge() {
		let nodeA = Node(with: 2)
		let nodeB = Node(with: 3)
		
		nodeA.addEdge(to: nodeB, weight: 34)
		nodeA.addEdge(to: nodeB, weight: 42)
		
		XCTAssertEqual(nodeA.edges[0].weight, 34)
	}
	
	func testDescription() {
		let nodeA = Node(with: 2)
		let nodeB = Node(with: 3)

		let descriptionA = String(describing: nodeA)
		let descriptionB = String(describing: nodeB)
		
		XCTAssertEqual(descriptionA, "N[2]")
		XCTAssertEqual(descriptionB, "N[3]")
	}
}





