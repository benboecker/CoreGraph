
//  GraphTest.swift
//  UniMaps
//
//  Created by Benni on 14.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import XCTest
@testable import CoreGraph

class GraphTests: XCTestCase {
	func testBuildingGraphWithInts() {
		var graph = Graph<Int>()

		let nodeA = graph.addNode(with: 1).data!
		let nodeB = graph.addNode(with: 2).data!
		let nodeC = graph.addNode(with: 3).data!
		let nodeD = graph.addNode(with: 4).data!
		let nodeE = graph.addNode(with: 5).data!
		let nodeF = graph.addNode(with: 3).error

		graph.addEdge(from: 1, to: 2, weight: 1)
		graph.addEdge(from: 1, to: 4, weight: 4)
		graph.addEdge(from: 2, to: 4, weight: 5)
		graph.addEdge(from: 2, to: 3, weight: 2)
		graph.addEdge(from: 4, to: 5, weight: 8)
		graph.addEdge(from: 4, to: 5, weight: 18) // Does not work and simply silently returns

		XCTAssertEqual(nodeF, GraphError.nodeAlreadyExists)
		XCTAssertEqual(graph.nodes.count, 5)
		XCTAssertTrue(graph.node(nodeA, hasEdgeTo: nodeD))
		XCTAssertFalse(graph.node(nodeB, hasEdgeTo: nodeE))
		XCTAssertFalse(graph.node(nodeC, hasEdgeTo: nodeE))
		XCTAssertTrue(graph.node(nodeD, hasEdgeTo: nodeA))
		XCTAssertTrue(graph.node(nodeD, hasEdgeTo: nodeE))		
	}

	func testGraphSubscript() {
		var graph = Graph<Int>()

		let nodeA = graph.addNode(with: 1).data!
		let nodeB = graph.addNode(with: 2).data!
		let nodeC = graph.addNode(with: 3).data!

		graph.addEdge(from: 1, to: 2, weight: 10)
		graph.addEdge(from: 1, to: 3, weight: 10)
		
		let testA = graph[nodeA]
		let testB = graph[nodeB]
		let testC = graph[nodeC]
		let testD = graph[4]

		XCTAssertEqual(testA?.count, 2)
		XCTAssertEqual(testB?.count, 1)
		XCTAssertEqual(testC?.count, 1)
		XCTAssertEqual(testA?.first?.weight, 10)
		XCTAssertNil(testD)
	}

	
	
	func testEmptyGraph() {
		let graph = Graph<String>()
		let shortestPathResult = graph.shortestPath(from: "A", to: "B")
		XCTAssertTrue(shortestPathResult.isUnexpected)
		XCTAssertEqual(shortestPathResult.error, GraphError.startingPOINotFound)
	}
	
	func testClearGraph() {
		var graph = Graph<String>()
		graph.addNode(with: "A")
		graph.addNode(with: "B")
		graph.addEdge(from: "A", to: "B", weight: 1)

		let shortestPathResult = graph.shortestPath(from: "A", to: "B")
		XCTAssertTrue(shortestPathResult.isExpected)

		graph.clear()

		let shortestPathResult2 = graph.shortestPath(from: "A", to: "B")
		XCTAssertTrue(shortestPathResult2.isUnexpected)
	}
	
	func testHasEdge() {
		var graph = Graph<String>()
		graph.addNode(with: "A")
		graph.addNode(with: "B")
		graph.addEdge(from: "A", to: "B", weight: 1)

		XCTAssertTrue(graph.node("A", hasEdgeTo: "B"))
		XCTAssertTrue(graph.node("B", hasEdgeTo: "A"))
		XCTAssertFalse(graph.node("A", hasEdgeTo: "A"))
		XCTAssertFalse(graph.node("A", hasEdgeTo: "C"))
		XCTAssertFalse(graph.node("C", hasEdgeTo: "C"))
	}
	
	func testGetSuccessorPaths() {
		var graph = Graph<String>()
		graph.addNode(with: "A") // A
		graph.addNode(with: "B") // B
		
		let path = Path.end.append("A", weight: 10)
		let pathC = Path.end.append("C", weight: 10)

		XCTAssertEqual(path.totalWeight, 10)
		XCTAssertEqual(graph.successorsPaths(for: path), [])
		XCTAssertEqual(graph.successorsPaths(for: pathC), [])		
	}
}



