////
////  RouteTests.swift
////  CoreGraphTests
////
////  Created by Benni on 15.01.18.
////  Copyright © 2018 Ben Boecker. All rights reserved.
////
//
//import Foundation
//import XCTest
//@testable import CoreGraph
//
//
//class RouteTests: XCTestCase {
//	func testEmptyRoute() {
//		let _ = Route()
//	}
//	
//	func testCreateRouteWithNoPathTotal() {
//		let node = Node(with: 23)
//		let path = Frontier.Path.node(data: node, weight: 12, previous: .end)
//		let route = Route(path: path)
//		XCTAssertNil(route)
//	}
//	
//	func testCreateRouteWithOneNode() {
//		let node = Node(with: 23)
//		let path = Frontier.Path.node(data: node, weight: 12, previous: .end)
//		let route = Route(path: path)
//		XCTAssertNotNil(route)
//		XCTAssertEqual(route?.waypoints.first?.waypoint, 23)
//		XCTAssertEqual(route?.waypoints.first?.distance, 12)
//	}
//	
//	func testCreateRoute() {
//		let node = Node(with: 23)
//		let nodeB = Node(with: 42)
//		let path = Frontier.Path.node(data: node, weight: 13, previous: .end)
//		let pathB = path.prepend(with: nodeB, weight: 23)
//		
//		let route = Route(path: pathB)
//
//		XCTAssertNotNil(route)
//		
//		XCTAssertEqual(route?.waypoints[0].waypoint, 42)
//		XCTAssertEqual(route?.waypoints[0].distance, 23)
//		XCTAssertEqual(route?.waypoints[1].waypoint, 23)
//		XCTAssertEqual(route?.waypoints[1].distance, 19)
//	}
//}

