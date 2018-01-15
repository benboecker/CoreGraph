//
//  RouteTests.swift
//  CoreGraphTests
//
//  Created by Benni on 15.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation
import XCTest
@testable import CoreGraph


class RouteTests: XCTestCase {
	func testEmptyRoute() {
		let _ = Route<Int>()
	}
	
	func testCreateRouteWithNoPathTotal() {
		let node = Node(with: 23)
		let path = Frontier<Int>.Path<Int>(destination: node)
		let route = Route(path: path)
		XCTAssertNil(route)
	}
	
	func testCreateRouteWithOneNode() {
		let node = Node(with: 23)
		let path = Frontier<Int>.Path<Int>(destination: node)
		path.total = 23
		let route = Route(path: path)
		XCTAssertNotNil(route)
		XCTAssertEqual(route?.waypoints.first?.waypoint, 23)
		XCTAssertEqual(route?.waypoints.first?.distance, 23)
	}
	
	func testCreateRoute() {
		let node = Node(with: 23)
		let nodeB = Node(with: 42)
		let path = Frontier<Int>.Path<Int>(destination: node)
		path.total = 42
		let pathB = Frontier<Int>.Path<Int>(destination: nodeB)
		pathB.total = 23
		
		path.previous = pathB
		
		let route = Route(path: path)

		XCTAssertNotNil(route)
		
		XCTAssertEqual(route?.waypoints[0].waypoint, 42)
		XCTAssertEqual(route?.waypoints[0].distance, 23)
		XCTAssertEqual(route?.waypoints[1].waypoint, 23)
		XCTAssertEqual(route?.waypoints[1].distance, 19)
	}
}
