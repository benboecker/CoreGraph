import Foundation
import XCTest
@testable import CoreGraph

class DijkstraTests: XCTestCase {
	
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
	
	func testShortestRouteWithInts() {
		var graph = Graph<Int>()
		
		graph.addNode(with: 1)
		graph.addNode(with: 2)
		graph.addNode(with: 3)
		graph.addNode(with: 4)
		graph.addNode(with: 5)
		
		graph.addEdge(from: 1, to: 2, weight: 1)
		graph.addEdge(from: 1, to: 4, weight: 4)
		graph.addEdge(from: 2, to: 4, weight: 5)
		graph.addEdge(from: 2, to: 3, weight: 2)
		graph.addEdge(from: 4, to: 5, weight: 8)
		
		let result = graph.shortestPath(from: 1, to: 5) { _ in 0 }
		
		XCTAssertTrue(result.isExpected)
		
		result.onExpected { route in
			XCTAssertEqual("\(route)", "[1] —4.0— [4] —8.0— [5]")
		}
		
		result.onUnexpected { error in
			XCTFail("\(error)")
		}
	}
	
	func testShortestRouteWithSrings() {
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
		
		let shortestPathResult = graph.shortestPath(from: "A", to: "E") { _ in 0 }
		
		XCTAssertTrue(shortestPathResult.isExpected)
		XCTAssertNotNil(shortestPathResult.data)
		XCTAssertEqual(shortestPathResult.data?.totalWeight, 12)
		
		XCTAssertEqual("\(shortestPathResult.data!)", "[A] —4.0— [D] —8.0— [E]")
		
		XCTAssertEqual(shortestPathResult.data?.nodeData.count, 3)
		XCTAssertEqual(shortestPathResult.data?.nodeData[0].node, "A")
		XCTAssertEqual(shortestPathResult.data?.nodeData[0].weight, 0)
		XCTAssertEqual(shortestPathResult.data?.nodeData[1].node, "D")
		XCTAssertEqual(shortestPathResult.data?.nodeData[1].weight, 4)
		XCTAssertEqual(shortestPathResult.data?.nodeData[2].node, "E")
		XCTAssertEqual(shortestPathResult.data?.nodeData[2].weight, 8)
	}
	
	func testSackgasse() {
		var graph = Graph<Int>()
		
		graph.addNode(with: 1)
		graph.addNode(with: 2)
		graph.addNode(with: 3)
		graph.addNode(with: 4)
		graph.addNode(with: 5)
		
		graph.addEdge(from: 1, to: 2, weight: 1)
		graph.addEdge(from: 1, to: 3, weight: 2)
		graph.addEdge(from: 2, to: 4, weight: 1)
		graph.addEdge(from: 2, to: 5, weight: 2)
		graph.addEdge(from: 3, to: 5, weight: 2)
		
		let shortestPathResult = graph.shortestPath(from: 1, to: 5)
		
		XCTAssertTrue(shortestPathResult.isExpected)
		XCTAssertNotNil(shortestPathResult.data)
		XCTAssertEqual(shortestPathResult.data?.totalWeight, 3)
		
		XCTAssertEqual("\(shortestPathResult.data!)", "[1] —1.0— [2] —2.0— [5]")
		
	}
	
	func testCircularGraphWithInts() {
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
		
		XCTAssertTrue(result.isExpected)
		
		result.onExpected { route in
			XCTAssertEqual("\(route)", "[1] —1.0— [2] —2.0— [3]")
		}
		
		result.onUnexpected { error in
			XCTFail("\(error)")
		}
	}
	
	func testCircularGraphWithInts2() {
		var graph = Graph<Int>()
		
		graph.addNode(with: 1)
		graph.addNode(with: 2)
		graph.addNode(with: 3)
		graph.addNode(with: 4)
		
		graph.addEdge(from: 1, to: 2, weight: 1)
		graph.addEdge(from: 2, to: 3, weight: 2)
		graph.addEdge(from: 3, to: 4, weight: 3)
		graph.addEdge(from: 4, to: 1, weight: 4)
		graph.addEdge(from: 3, to: 1, weight: 4)
		graph.addEdge(from: 4, to: 2, weight: 1)
		
		let result = graph.shortestPath(from: 1, to: 3)
		
		XCTAssertTrue(result.isExpected)
		
		result.onExpected { route in
			XCTAssertEqual(route.nodeData[0].node, 1)
			XCTAssertEqual(route.nodeData[1].node, 2)
			XCTAssertEqual(route.nodeData[2].node, 3)
		}
		
		result.onUnexpected { error in
			XCTFail("\(error)")
		}
	}
	
	func testShortestRouteWithStrings2() {
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
		
		XCTAssertTrue(shortestPathResult.isExpected)
		
		XCTAssertEqual(shortestPathResult.data?.nodeData.count, 4)
		XCTAssertEqual(shortestPathResult.data?.nodeData[0].node, "KA")
		XCTAssertEqual(shortestPathResult.data?.nodeData[0].weight, 0)
		XCTAssertEqual(shortestPathResult.data?.nodeData[1].node, "OL")
		XCTAssertEqual(shortestPathResult.data?.nodeData[1].weight, 231)
		XCTAssertEqual(shortestPathResult.data?.nodeData[2].node, "KS")
		XCTAssertEqual(shortestPathResult.data?.nodeData[2].weight, 117)
		XCTAssertEqual(shortestPathResult.data?.nodeData[3].node, "MI")
		XCTAssertEqual(shortestPathResult.data?.nodeData[3].weight, 190)
	}
	
	func testShortestRouteWithStructs() {
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
		
		XCTAssertTrue(shortestPathResult.isExpected)
		shortestPathResult.onExpected { path in
			XCTAssertEqual(path.totalWeight, 220.0)
			XCTAssertEqual(path.nodeData[0].node.name, "Rheine")
			XCTAssertEqual(path.nodeData[1].node.name, "Münster")
			XCTAssertEqual(path.nodeData[2].node.name, "Düsseldorf")
			XCTAssertEqual(path.nodeData[3].node.name, "Köln")
			XCTAssertEqual(path.nodeData[0].weight, 0.0)
			XCTAssertEqual(path.nodeData[1].weight, 50.0)
			XCTAssertEqual(path.nodeData[2].weight, 130.0)
			XCTAssertEqual(path.nodeData[3].weight, 40.0)
		}
		
		let shortestPathResult2 = graph.shortestPath(from: duesseldorf, to: bielefeld)
		
		XCTAssertTrue(shortestPathResult2.isExpected)
		shortestPathResult2.onExpected { path in
			XCTAssertEqual(path.totalWeight, 170.0)
			XCTAssertEqual(path.nodeData[0].node.name, "Düsseldorf")
			XCTAssertEqual(path.nodeData[1].node.name, "Dortmund")
			XCTAssertEqual(path.nodeData[2].node.name, "Bielefeld")
			XCTAssertEqual(path.nodeData[0].weight, 0.0)
			XCTAssertEqual(path.nodeData[1].weight, 70.0)
			XCTAssertEqual(path.nodeData[2].weight, 100.0)
		}
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
}


