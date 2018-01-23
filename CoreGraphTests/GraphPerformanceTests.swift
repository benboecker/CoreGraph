//
//  GraphPerformanceTests.swift
//  CoreGraphTests
//
//  Created by Benni on 15.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation
import XCTest
@testable import CoreGraph




class GraphPerformanceTests: XCTestCase {

	var graph: Graph<Int>!
	
	override func setUp() {
		super.setUp()
		
		graph = Graph()
		
		loadRoutingData()

	}
	
	func testPerformance() {
		_measure("Westend -> Sammelplatz 1") {
			let shortestPath = graph.shortestPath(from: -35330, to: -39502, minimum: 1)
			XCTAssertTrue(shortestPath.isExpected)
		}
		_measure("Westend -> Eddy") {
			let shortestPath = graph.shortestPath(from: -35330, to: -34774, minimum: 1)
			XCTAssertTrue(shortestPath.isExpected)
		}

		_measure("Westend -> Sammelplatz 2") {
			let shortestPath = graph.shortestPath(from: -35330, to: -39504, minimum: 1)
			XCTAssertTrue(shortestPath.isExpected)
		}

		_measure("Westend -> Nördlicher Gang") {
			let shortestPath = graph.shortestPath(from: -35330, to: -35040, minimum: 1)
			XCTAssertTrue(shortestPath.isExpected)
		}

		_measure("Westend -> Infopunkt") {
			let shortestPath = graph.shortestPath(from: -35330, to: -35536, minimum: 1)
			XCTAssertTrue(shortestPath.isExpected)
		}

		_measure("Sammelplatz 2 -> Westend") {
			let shortestPath = graph.shortestPath(from: -39504, to: -35330, minimum: 1)
			XCTAssertTrue(shortestPath.isExpected)
		}

		_measure("Westend -> Audimax") {
			let shortestPath = graph.shortestPath(from: -39504, to: -35516, minimum: 1)
			XCTAssertTrue(shortestPath.isExpected)
		}
	}
}


extension GraphPerformanceTests {
	func loadRoutingData() {
		let testBundle = Bundle(for: type(of: self))

		guard let url = testBundle.url(forResource: "routing", withExtension: "plist") else {
			return
		}

		do {
			let data = try NSArray(contentsOf: url, error: ()) as! [[String: Any]]

			for dict in data {
				guard !(dict["ways"] as! [[String: Any]]).isEmpty,
					let id = dict["id"] as? Int
					else { continue }
				
				graph.addNode(with: id)
				
				for edge in (dict["ways"] as! [[String: Any]]) {
					let destination = edge["destinationId"] as? Int ?? 0
					let distance = edge["distance"] as? Double ?? 0.0
					
					graph.addEdge(from: id, to: destination, weight: distance)
				}
			}
		} catch {
			print("\(error.localizedDescription)")
		}
	}
}




func _measure(_ title: String? = nil, call: () -> Void) {
	let startTime = CACurrentMediaTime()
	call()
	let endTime = CACurrentMediaTime()
	
	print("--------------------------------------------")
	if let title = title {
		print("\(title): Time - \(endTime - startTime)")
	} else {
		print("Time - \(endTime - startTime)")
	}
	print("--------------------------------------------")
}

