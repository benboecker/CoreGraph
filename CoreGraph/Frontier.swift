//
//  Frontier.swift
//  UniMaps
//
//  Created by Benni on 09.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation



class Frontier {
	var paths = MinHeap<Path>()
}

// MARK: - Public methods and properties
extension Frontier {
	var isEmpty: Bool {
		return paths.isEmpty
	}
	
	func removeAllPaths() {
		paths.removeAll()
	}
	
	func getBestPath() -> Result<Path> {
		guard !isEmpty else { return .unexpected(.frontierIsEmpty) }

		return .expected(paths[0])
	}
	
	func add(_ path: Path) {
		paths.add(path)
	}
	
	@discardableResult func removeBestPath() -> Result<Int> {
		guard !paths.isEmpty else {
			return .unexpected(GraphError.elementNotRemoved)
		}
		paths.remove()
		
		return .expected(0)
	}
}

// MARK: - Frontier CustomStringConvertible
extension Frontier: CustomStringConvertible {
	var description: String {
		return ""
		//return paths.map { "\($0)" }.joined(separator: "\n")
	}
}
