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

		graph = Graph<Int>()

		loadRoutingData()
	}

	func testWestendToEddy() {
		measure() {
			let shortestPath = graph.shortestPath(from: -35330, to: -34774)
			
			XCTAssertTrue(shortestPath.isExpected)
		}
	}
	
	func testWestendToSammelplatz1() {
		measure() {
			let shortestPath = graph.shortestPath(from: -35330, to: -39502)
			XCTAssertTrue(shortestPath.isExpected)
		}
	}
	
	func testWestendToSammelplatz2() {
		measure() {
			let shortestPath = graph.shortestPath(from: -35330, to: -39504)
			XCTAssertTrue(shortestPath.isExpected)
		}
	}
	
	func testWestendToNördlicherGang() {
		measure() {
			let shortestPath = graph.shortestPath(from: -35330, to: -35040)
			XCTAssertTrue(shortestPath.isExpected)
		}

	}
	
	func testWestendToInfopunkt() {
		measure() {
			let shortestPath = graph.shortestPath(from: -35330, to: -35536)
			XCTAssertTrue(shortestPath.isExpected)
		}

	}
	
	func testSammelplatz2ToWestend() {
		measure() {
			let shortestPath = graph.shortestPath(from: -39504, to: -35330)
			XCTAssertTrue(shortestPath.isExpected)
		}
	}
	
	func testWestEndToAudiMax() {
		measure() {
			let shortestPath = graph.shortestPath(from: -39504, to: -35516)
			
			XCTAssertTrue(shortestPath.isExpected)
		}
	}
}

extension GraphPerformanceTests {
	func loadRoutingData() {
		let testBundle = Bundle(for: type(of: self))

		guard let url = testBundle.url(forResource: "routing-all", withExtension: "plist") else {
			return
		}

		do {
			let data = try NSArray(contentsOf: url, error: ()) as! [[String: Any]]

			for dict in data {
				guard !(dict["ways"] as! [[String: Any]]).isEmpty,
					let id = dict["id"] as? Int
					else { continue }
				
				graph.addNode(with: id)
			}
			
			for dict in data {
				guard !(dict["ways"] as! [[String: Any]]).isEmpty,
					let id = dict["id"] as? Int
					else { continue }
				
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
