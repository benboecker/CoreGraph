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

	struct City: Equatable, Hashable {
		var hashValue: Int {
			return name.hashValue
		}

		let name: String
		let population: Int

		static func ==(left: City, right: City) -> Bool {
			return left.name == right.name && left.population == right.population
		}
	}


	func testBuildingGraph() {
		var graph = Graph<Int>()

		let nodeA = graph.addNode(with: 1).data!
		let _ = graph.addNode(with: 2)
		let _ = graph.addNode(with: 3)
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
		XCTAssertTrue(graph.nodes[1]!.hasEdge(to: nodeD))
		XCTAssertFalse(graph.nodes[2]!.hasEdge(to: nodeE))
		XCTAssertFalse(graph.nodes[2]!.hasEdge(to: nodeE))
		XCTAssertTrue(graph.nodes[4]!.hasEdge(to: nodeA))
		XCTAssertTrue(graph.nodes[4]!.hasEdge(to: nodeE))

//		let description = """
//N[1]
//	—1.0— [2]
//	—4.0— [4]
//N[2]
//	—1.0— [1]
//	—5.0— [4]
//	—2.0— [3]
//N[3]
//	—2.0— [2]
//N[4]
//	—4.0— [1]
//	—5.0— [2]
//	—8.0— [5]
//N[5]
//	—8.0— [4]
//"""
		//XCTAssertEqual(String(describing: graph), description)
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

		XCTAssertEqual(nodeA, testA!.value)
		XCTAssertEqual(nodeB, testB!.value)
		XCTAssertEqual(nodeC, testC!.value)
		XCTAssertNil(testD)
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


	func testShortestRoute1() {
		var graph = Graph<String>()

		graph.addNode(with: "A") // A
		graph.addNode(with: "B") // B
		graph.addNode(with: "C") // C
		graph.addNode(with: "D") // D
		graph.addNode(with: "E") // E

		graph.addEdge(from: "A", to: "B", weight: 1)
		graph.addEdge(from: "A", to: "D", weight: 4)
		graph.addEdge(from: "B", to: "C", weight: 2)
		graph.addEdge(from: "B", to: "D", weight: 5)
		graph.addEdge(from: "D", to: "E", weight: 8)

		let shortestPathResult = graph.shortestPath(from: "A", to: "E")

		XCTAssertTrue(shortestPathResult.isExpected)
		XCTAssertNotNil(shortestPathResult.data)
		XCTAssertEqual(shortestPathResult.data?.totalDistance, 12)

		XCTAssertEqual("\(shortestPathResult.data!)", "[A] —4.0— [D] —8.0— [E]")

		XCTAssertEqual(shortestPathResult.data?.waypoints.count, 3)
		XCTAssertEqual(shortestPathResult.data?.waypoints[0].waypoint, "A")
		XCTAssertEqual(shortestPathResult.data?.waypoints[0].distance, 0)
		XCTAssertEqual(shortestPathResult.data?.waypoints[1].waypoint, "D")
		XCTAssertEqual(shortestPathResult.data?.waypoints[1].distance, 4)
		XCTAssertEqual(shortestPathResult.data?.waypoints[2].waypoint, "E")
		XCTAssertEqual(shortestPathResult.data?.waypoints[2].distance, 8)
	}

	func testCircularGraph() {
		var graph = Graph<Int>()

		graph.addNode(with: 1)
		graph.addNode(with: 2)
		graph.addNode(with: 3)
		graph.addNode(with: 4)

		graph.addEdge(from: 1, to: 2, weight: 1)
		graph.addEdge(from: 2, to: 3, weight: 2)
		graph.addEdge(from: 3, to: 4, weight: 3)
		graph.addEdge(from: 4, to: 1, weight: 4)

		let result = graph.shortestPath(from: 1, to: 3)

		XCTAssertFalse(result.isUnexpected)

		result.onExpected { route in
			XCTAssertEqual("\(route)", "[1] —1.0— [2] —2.0— [3]")
		}

		result.onUnexpected { error in
			XCTFail("\(error)")
		}
	}

	func testCircularGraph2() {
		var graph = Graph<Int>()

		graph.addNode(with: 1)
		graph.addNode(with: 2)
		graph.addNode(with: 3)
		graph.addNode(with: 4)

		graph.addEdge(from: 1, to: 2, weight: 1)
		graph.addEdge(from: 2, to: 3, weight: 2)
		graph.addEdge(from: 3, to: 4, weight: 3)
		graph.addEdge(from: 4, to: 1, weight: 4)
		graph.addEdge(from: 3, to: 1, weight: 1)
		graph.addEdge(from: 4, to: 2, weight: 1)

		let result = graph.shortestPath(from: 1, to: 3)

		XCTAssertTrue(result.isExpected)

		result.onExpected { route in
			//XCTAssertEqual("\(route)", "[1] —1.0— [2] —2.0— [3]")
		}

		result.onUnexpected { error in
			XCTFail("\(error)")
		}
	}

	func testShortestRoute2() {
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

		let shortestPathResult = graph.shortestPath(from: "KA", to: "MI")

		XCTAssertEqual(shortestPathResult.data?.waypoints.count, 4)
		XCTAssertEqual(shortestPathResult.data?.waypoints[0].waypoint, "KA")
		XCTAssertEqual(shortestPathResult.data?.waypoints[0].distance, 0)
		XCTAssertEqual(shortestPathResult.data?.waypoints[1].waypoint, "OL")
		XCTAssertEqual(shortestPathResult.data?.waypoints[1].distance, 231)
		XCTAssertEqual(shortestPathResult.data?.waypoints[2].waypoint, "KS")
		XCTAssertEqual(shortestPathResult.data?.waypoints[2].distance, 117)
		XCTAssertEqual(shortestPathResult.data?.waypoints[3].waypoint, "MI")
		XCTAssertEqual(shortestPathResult.data?.waypoints[3].distance, 190)
	}

	func testShortestRouteCity() {
		let muenster = City(name: "Münster", population: 310_000)
		let bielefeld = City(name: "Bielefeld", population: 300_000)
		let cologne = City(name: "Köln", population: 1_000_000)
		let rheine = City(name: "Rheine", population: 50_000)
		let dortmund = City(name: "Dortmund", population: 600_000)
		let duesseldorf = City(name: "Düsseldorf", population: 500_000)

		var graph = Graph<City>()

		graph.addNode(with: muenster)
		graph.addNode(with: bielefeld)
		graph.addNode(with: cologne)
		graph.addNode(with: rheine)
		graph.addNode(with: dortmund)
		graph.addNode(with: duesseldorf)

		graph.addEdge(from: muenster, to: rheine, weight: 50)
		graph.addEdge(from: muenster, to: dortmund, weight: 80)
		graph.addEdge(from: dortmund, to: bielefeld, weight: 100)
		graph.addEdge(from: dortmund, to: cologne, weight: 120)
		graph.addEdge(from: dortmund, to: duesseldorf, weight: 70)
		graph.addEdge(from: muenster, to: duesseldorf, weight: 130)
		graph.addEdge(from: duesseldorf, to: cologne, weight: 40)

		let shortestPathResult = graph.shortestPath(from: rheine, to: cologne)

		shortestPathResult.onExpected { route in
			XCTAssertEqual(route.totalDistance, 220.0)
			XCTAssertEqual(route.waypoints[0].waypoint.name, "Rheine")
			XCTAssertEqual(route.waypoints[1].waypoint.name, "Münster")
			XCTAssertEqual(route.waypoints[2].waypoint.name, "Düsseldorf")
			XCTAssertEqual(route.waypoints[3].waypoint.name, "Köln")
			XCTAssertEqual(route.waypoints[0].distance, 0.0)
			XCTAssertEqual(route.waypoints[1].distance, 50.0)
			XCTAssertEqual(route.waypoints[2].distance, 130.0)
			XCTAssertEqual(route.waypoints[3].distance, 40.0)
		}

		let shortestPathResult2 = graph.shortestPath(from: duesseldorf, to: bielefeld)
		shortestPathResult2.onExpected { route in
			XCTAssertEqual(route.totalDistance, 170.0)
			XCTAssertEqual(route.waypoints[0].waypoint.name, "Düsseldorf")
			XCTAssertEqual(route.waypoints[1].waypoint.name, "Dortmund")
			XCTAssertEqual(route.waypoints[2].waypoint.name, "Bielefeld")
			XCTAssertEqual(route.waypoints[0].distance, 0.0)
			XCTAssertEqual(route.waypoints[1].distance, 70.0)
			XCTAssertEqual(route.waypoints[2].distance, 100.0)
		}
	}

	func testEmptyGraph() {
		let graph = Graph<String>()
		let shortestPathResult = graph.shortestPath(from: "A", to: "B")
		XCTAssertTrue(shortestPathResult.isUnexpected)
		XCTAssertEqual(shortestPathResult.error, GraphError.startingPOINotFound)
	}

	func testDestinationNotFound() {
		var graph = Graph<String>()
		graph.addNode(with: "A")
		let shortestPathResult = graph.shortestPath(from: "A", to: "B")
		XCTAssertTrue(shortestPathResult.isUnexpected)
		XCTAssertEqual(shortestPathResult.error, GraphError.destinationPOINotFound)
	}

	func testBestPathNotFound() {
		var graph = Graph<String>()
		graph.addNode(with: "A")
		graph.addNode(with: "B")
		let shortestPathResult = graph.shortestPath(from: "A", to: "B")
		XCTAssertEqual(shortestPathResult.error, GraphError.shortestPathNotFound)
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
}



