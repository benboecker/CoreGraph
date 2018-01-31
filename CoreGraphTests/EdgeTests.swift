//
//  EdgeTests.swift
//  CoreGraphTests
//
//  Created by Benni on 12.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation
import XCTest
@testable import CoreGraph

class EdgeTests: XCTestCase {
	
	func testCreateEdge() {
		let edge = Edge(to: 12, weight: 8.0)
	
		XCTAssertEqual(edge.destination, 12)
		XCTAssertEqual(edge.weight, 8.0)
	}
}
