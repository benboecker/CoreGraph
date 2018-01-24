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
		var nodeA = Node(with: 2)
		let nodeB = Node(with: 3)
		let nodeC = Node(with: 4)
		
		nodeA.addEdge(to: nodeB, weight: 2)
		nodeA.addEdge(to: nodeC, weight: 3)
		
		XCTAssertTrue(nodeA.hasEdge(to: 3))
		XCTAssertTrue(nodeA.hasEdge(to: 4))
		XCTAssertFalse(nodeB.hasEdge(to: 4))
	}
	
	func testGetEdgeToAnotherNode() {
		var nodeA = Node(with: 2)
		let nodeB = Node(with: 3)
		let nodeC = Node(with: 4)
		
		nodeA.addEdge(to: nodeB, weight: 2)
		nodeA.addEdge(to: nodeC, weight: 3)
		
		let edgeAToB = nodeA.edge(to: nodeB)
		let edgeAToC = nodeA.edge(to: nodeC)
		
		XCTAssertTrue(edgeAToB.isExpected)
		XCTAssertTrue(edgeAToC.isExpected)
		XCTAssertTrue(nodeB.edge(to: nodeC).isUnexpected)
		
		XCTAssertEqual(edgeAToB.data?.weight, 2)
		XCTAssertEqual(edgeAToC.data?.weight, 3)
	}
	
	func testAddEdge() {
		var nodeA = Node(with: 2)
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





