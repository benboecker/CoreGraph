//
//  GraphTest.swift
//  UniMaps
//
//  Created by Benni on 14.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import XCTest
@testable import CoreGraph

class GraphTest: XCTestCase {
	
	struct City: Equatable {
		let name: String
		let population: Int

		static func ==(left: City, right: City) -> Bool {
			return left.name == right.name && left.population == right.population
		}
	}


	func testBuildingGraph() {
		var graph = Graph<Int>()

		let nodeA = graph.addNode(with: 1).data!
		graph.addNode(with: 2)
		graph.addNode(with: 3)
		let nodeD = graph.addNode(with: 4).data!
		let nodeE = graph.addNode(with: 5).data!
		let nodeF = graph.addNode(with: 3).error

		graph.addEdge(from: 1, to: 2, weight: 1)
		graph.addEdge(from: 1, to: 4, weight: 4)
		graph.addEdge(from: 2, to: 4, weight: 5)
		graph.addEdge(from: 2, to: 3, weight: 2)
		graph.addEdge(from: 4, to: 5, weight: 8)

		XCTAssertEqual(nodeF, GraphError.nodeAlreadyExists)
		
		XCTAssertEqual(graph.nodes.count, 5)
		XCTAssertTrue(graph.nodes[0].hasEdge(to: nodeD))
		XCTAssertTrue(graph.nodes[3].hasEdge(to: nodeE))
		XCTAssertFalse(graph.nodes[1].hasEdge(to: nodeE))
		XCTAssertTrue(graph.nodes[1].hasEdge(to: nodeA))
		
		let description = """
N[1]
	—1.0— [2]
	—4.0— [4]
N[2]
	—1.0— [1]
	—5.0— [4]
	—2.0— [3]
N[3]
	—2.0— [2]
N[4]
	—4.0— [1]
	—5.0— [2]
	—8.0— [5]
N[5]
	—8.0— [4]
"""
		XCTAssertEqual(String(describing: graph), description)
	}

	func testGraphSubscript() {
		var graph = Graph<Int>()

		let nodeA = graph.addNode(with: 1).data!
		let nodeB = graph.addNode(with: 2).data!
		let nodeC = graph.addNode(with: 3).data!

		let testA = graph[1]
		let testB = graph[2]
		let testC = graph[3]
		let testD = graph[4]

		XCTAssertEqual(nodeA, testA)
		XCTAssertEqual(nodeB, testB)
		XCTAssertEqual(nodeC, testC)
		XCTAssertNil(testD)

		XCTAssert(nodeA === testA)
		XCTAssert(nodeB === testB)
		XCTAssert(nodeC === testC)
	}

	func testBuildingGraphWithStrings() {
		var graph = Graph<String>()

		graph.addNode(with: "KA") // A
		graph.addNode(with: "OL") // B
		graph.addNode(with: "ZH") // C
		graph.addNode(with: "LU") // D
		graph.addNode(with: "MI") // E
		graph.addNode(with: "KS") // F
		graph.addNode(with: "BZ") // G

		graph.addEdge(from: "KA", to: "OL", weight: 231)
		graph.addEdge(from: "KA", to: "ZH", weight: 265)
		graph.addEdge(from: "OL", to: "ZH", weight: 65)
		graph.addEdge(from: "OL", to: "LU", weight: 53)

		graph.addEdge(from: "ZH", to: "LU", weight: 58)
		graph.addEdge(from: "OL", to: "KS", weight: 117)
		graph.addEdge(from: "LU", to: "KS", weight: 78)
		graph.addEdge(from: "ZH", to: "BZ", weight: 183)
		graph.addEdge(from: "LU", to: "BZ", weight: 141)
		graph.addEdge(from: "KS", to: "MI", weight: 190)
		graph.addEdge(from: "BZ", to: "MI", weight: 222)
	}

//	func testCircular() {
//		var graph = Graph<Int>()
//
//		graph.addNode(with: 1)
//		graph.addNode(with: 2)
//		graph.addNode(with: 3)
//		graph.addNode(with: 4)
//
//		graph.addEdge(from: 1, to: 2, weight: 4)
//		graph.addEdge(from: 2, to: 3, weight: 4)
//		graph.addEdge(from: 3, to: 4, weight: 4)
//		graph.addEdge(from: 4, to: 1, weight: 4)
//
//
//		let result = graph.shortestPath(from: 1, to: 3)
//
//		result.onExpected { route in
//
//		}
//
//		result.onUnexpected { error in
//			XCTFail("\(error)")
//		}
//	}
//
//	func testShortestRoute1() {
//		var graph = Graph<String>()
//
//		graph.addNode(with: "A") // A
//		graph.addNode(with: "B") // B
//		graph.addNode(with: "C") // C
//		graph.addNode(with: "D") // D
//		graph.addNode(with: "E") // E
//
//		graph.addEdge(from: "A", to: "B", weight: 1)
//		graph.addEdge(from: "A", to: "D", weight: 4)
//		graph.addEdge(from: "B", to: "C", weight: 2)
//		graph.addEdge(from: "B", to: "D", weight: 5)
//		graph.addEdge(from: "D", to: "E", weight: 8)
//
////		guard let shortestRoute = graph.shortestPath(from: "A", to: "E"), shortestRoute.waypoints.count == 3 else {
////			XCTFail()
////			return
////		}
//
////		XCTAssertEqual(shortestRoute.waypoints.count, 3)
////		XCTAssertEqual(shortestRoute.waypoints[0].waypoint, "A")
////		XCTAssertEqual(shortestRoute.waypoints[0].distance, 0)
////		XCTAssertEqual(shortestRoute.waypoints[1].waypoint, "D")
////		XCTAssertEqual(shortestRoute.waypoints[1].distance, 4)
////		XCTAssertEqual(shortestRoute.waypoints[2].waypoint, "E")
////		XCTAssertEqual(shortestRoute.waypoints[2].distance, 8)
//	}
//
//	func testShortestRoute2() {
//		var graph = Graph<String>()
//
//		graph.addNode(with: "KA") // A
//		graph.addNode(with: "OL") // B
//		graph.addNode(with: "ZH") // C
//		graph.addNode(with: "LU") // D
//		graph.addNode(with: "MI") // E
//		graph.addNode(with: "KS") // F
//		graph.addNode(with: "BZ") // G
//
//		graph.addEdge(from: "KA", to: "OL", weight: 231)
//		graph.addEdge(from: "KA", to: "ZH", weight: 265)
//		graph.addEdge(from: "OL", to: "ZH", weight: 65)
//		graph.addEdge(from: "OL", to: "LU", weight: 53)
//		graph.addEdge(from: "ZH", to: "LU", weight: 58)
//		graph.addEdge(from: "OL", to: "KS", weight: 117)
//		graph.addEdge(from: "LU", to: "KS", weight: 78)
//		graph.addEdge(from: "ZH", to: "BZ", weight: 183)
//		graph.addEdge(from: "LU", to: "BZ", weight: 141)
//		graph.addEdge(from: "KS", to: "MI", weight: 190)
//		graph.addEdge(from: "BZ", to: "MI", weight: 222)
//
////		guard let shortestRoute = graph.shortestPath(from: "KA", to: "MI"), shortestRoute.waypoints.count == 4 else {
////			XCTFail()
////			return
////		}
//
////		XCTAssertEqual(shortestRoute.waypoints.count, 4)
////		XCTAssertEqual(shortestRoute.waypoints[0].waypoint, "KA")
////		XCTAssertEqual(shortestRoute.waypoints[0].distance, 0)
////		XCTAssertEqual(shortestRoute.waypoints[1].waypoint, "OL")
////		XCTAssertEqual(shortestRoute.waypoints[1].distance, 231)
////		XCTAssertEqual(shortestRoute.waypoints[2].waypoint, "KS")
////		XCTAssertEqual(shortestRoute.waypoints[2].distance, 117)
////		XCTAssertEqual(shortestRoute.waypoints[3].waypoint, "MI")
////		XCTAssertEqual(shortestRoute.waypoints[3].distance, 190)
//	}
//
//	func testShortestRouteCity() {
//		let muenster = City(name: "Münster", population: 310_000)
//		let bielefeld = City(name: "Bielefeld", population: 300_000)
//		let cologne = City(name: "Köln", population: 1_000_000)
//		let rheine = City(name: "Rheine", population: 50_000)
//		let dortmund = City(name: "Dortmund", population: 600_000)
//		let duesseldorf = City(name: "Düsseldorf", population: 500_000)
//
//		var graph = Graph<City>()
//
//		graph.addNode(with: muenster)
//		graph.addNode(with: bielefeld)
//		graph.addNode(with: cologne)
//		graph.addNode(with: rheine)
//		graph.addNode(with: dortmund)
//		graph.addNode(with: duesseldorf)
//
//		graph.addEdge(from: muenster, to: rheine, weight: 50)
//		graph.addEdge(from: muenster, to: dortmund, weight: 80)
//		graph.addEdge(from: dortmund, to: bielefeld, weight: 100)
//		graph.addEdge(from: dortmund, to: cologne, weight: 120)
//		graph.addEdge(from: dortmund, to: duesseldorf, weight: 70)
//		graph.addEdge(from: muenster, to: duesseldorf, weight: 130)
//		graph.addEdge(from: duesseldorf, to: cologne, weight: 40)
//
////		guard let shortestPath = graph.shortestPath(from: rheine, to: cologne) else {
////			XCTFail()
////			return
////		}
//
////		XCTAssertEqual(shortestPath.totalDistance, 220.0)
////		XCTAssertEqual(shortestPath.waypoints[0].waypoint.name, "Rheine")
////		XCTAssertEqual(shortestPath.waypoints[1].waypoint.name, "Münster")
////		XCTAssertEqual(shortestPath.waypoints[2].waypoint.name, "Düsseldorf")
////		XCTAssertEqual(shortestPath.waypoints[3].waypoint.name, "Köln")
////		XCTAssertEqual(shortestPath.waypoints[0].distance, 0.0)
////		XCTAssertEqual(shortestPath.waypoints[1].distance, 50.0)
////		XCTAssertEqual(shortestPath.waypoints[2].distance, 130.0)
////		XCTAssertEqual(shortestPath.waypoints[3].distance, 40.0)
//
////		guard let shortestPath2 = graph.shortestPath(from: duesseldorf, to: bielefeld) else {
////			XCTFail()
////			return
////		}
//
////		XCTAssertEqual(shortestPath2.totalDistance, 170.0)
////		XCTAssertEqual(shortestPath2.waypoints[0].waypoint.name, "Düsseldorf")
////		XCTAssertEqual(shortestPath2.waypoints[1].waypoint.name, "Dortmund")
////		XCTAssertEqual(shortestPath2.waypoints[2].waypoint.name, "Bielefeld")
////		XCTAssertEqual(shortestPath2.waypoints[0].distance, 0.0)
////		XCTAssertEqual(shortestPath2.waypoints[1].distance, 70.0)
////		XCTAssertEqual(shortestPath2.waypoints[2].distance, 100.0)
//
//	}
}


