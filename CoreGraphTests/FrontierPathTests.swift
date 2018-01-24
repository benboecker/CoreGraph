////
////  FrontierPathTests.swift
////  CoreGraphTests
////
////  Created by Benni on 12.01.18.
////  Copyright © 2018 Ben Boecker. All rights reserved.
////
//
//import Foundation
//import XCTest
//@testable import CoreGraph
//
//class FrontierPathTests: XCTestCase {
//	
//	var path: Frontier.Path!
//	
//	override func setUp() {
//		super.setUp()
//		
//		let nodeA = Node(with: 23)
//		let nodeB = Node(with: 38)
//		let nodeC = Node(with: 42)
//		
//		let pathA = Frontier.Path(destination: nodeA)
//		let pathB = Frontier.Path(destination: nodeB)
//		let pathC = Frontier.Path(destination: nodeC)
//		
//		pathB.previous = pathA
//		pathC.previous = pathB
//		
//		path = pathC
//		path.previous = pathB
//		path.previous?.previous = pathA
//		path.totalWeight = 139
//	}
//	
//	
//	
////	func testGetNodeValues() {
////		let nodes = path.nodeValues
////
////		XCTAssertEqual(nodes, [42, 38, 23])
////	}
//	
//	func testGetDescription() {
//		//XCTAssertEqual("\(path!)", "[42] — [38] — [23]")
//	}
//	
//	func testHasNode() {
//		XCTAssertTrue(path.has(node: Node(with: 42)))
//		XCTAssertTrue(path.has(node: Node(with: 23)))
//		XCTAssertFalse(path.has(node: Node(with: 41223232)))
//	}
//	
//	func testEquality() {
//		let pathCopy = path
//		
//		let node = Node(with: 42)
//		let secondPath = Frontier<Int>.Path<Int>(destination: node)
//		secondPath.total = 987
//
//		XCTAssertTrue(path == pathCopy)
//		XCTAssertFalse(path == secondPath)
//	}
//	
//	func testComparable() {
//		let node = Node(with: 42)
//		let secondPath = Frontier<Int>.Path<Int>(destination: node)
//		secondPath.total = 987
//
//		let less = path < secondPath
//		
//		XCTAssertTrue(less)
//	}
//}
//
//
//
