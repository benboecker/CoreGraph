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


extension Frontier {
	enum Path {
		case end
		indirect case node(data: Node, weight: Double, previous: Path)
	}
}

extension Frontier.Path {
	func prepend(with data: Node, weight: Double) -> Frontier.Path {
		return .node(data: data, weight: weight, previous: self)
	}
	
	func contains(_ element: Node) -> Bool {
		if case let .node(data, _, previous) = self {
			if data == element {
				return true
			} else {
				return previous.contains(element)
			}
		} else {
			return false
		}
	}
	
	var destination: Node? {
		if case .node(let destination, _, _) = self {
			return destination
		} else {
			return nil
		}
	}
	
	var previous: Frontier.Path? {
		if case .node(_, _, let previous) = self {
			return previous
		} else {
			return nil
		}
	}
	
	var weight: Double? {
		if case .node(_, let weight, _) = self {
			return weight
		} else {
			return nil
		}
	}
	
	var totalWeight: Double {
		if case .node(_, let weight, let previous) = self {
			return weight + previous.totalWeight
		} else {
			return 0
		}
	}
}

// MARK: - Frontier.Path CustomStringConvertible
extension Frontier.Path: CustomStringConvertible {
	var description: String {
		if case .node(_, _, _) = self {
			return "w[\(totalWeight)]"
		} else {
			return ""
		}
	}
}

// MARK: - Frontier.Path Equatable
extension Frontier.Path: Equatable {
	static func ==(left: Frontier.Path, right: Frontier.Path) -> Bool {
		switch (left, right) {
		case (.node(_,_,_), .node(_,_,_)) where left.totalWeight == right.totalWeight: return true
		case (.end, .end): return true
		default: return false
		}
	}
}

// MARK: - Frontier.Path Comparable
extension Frontier.Path: Comparable {
	static func < (left: Frontier.Path, right: Frontier.Path) -> Bool {
		switch (left, right) {
		case (.node(_,_,_), .node(_,_,_)) where left.totalWeight < right.totalWeight: return true
		case (.end, .end): return true
		default: return false
		}
	}
}

