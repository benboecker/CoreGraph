//
//  Path.swift
//  CoreGraph
//
//  Created by Benni on 24.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

public enum Path {
	case end
	indirect case node(data: Node, weight: Double, previous: Path)
}

extension Path {
	func prepend(with data: Node, weight: Double) -> Path {
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
	
	var previous: Path? {
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
	
	var route: [(Node, Double)] {
		if case let .node(node, weight, previous) = self {
			return [(node, weight)] + previous.route
		} else {
			return []
		}
	}
}

// MARK: - Frontier.Path CustomStringConvertible
extension Path: CustomStringConvertible {
	public var description: String {
		return route.reversed().map { (node, weight) -> String in
			if weight == 0 {
				return "[\(node.value)]"
			} else {
				return " —\(weight)— [\(node.value)]"
			}
		}.joined()
	}
}

// MARK: - Frontier.Path Equatable
extension Path: Equatable {
	public static func ==(left: Path, right: Path) -> Bool {
		switch (left, right) {
		case (.node(_,_,_), .node(_,_,_)) where left.totalWeight == right.totalWeight: return true
		case (.end, .end): return true
		default: return false
		}
	}
}

// MARK: - Frontier.Path Comparable
extension Path: Comparable {
	public static func < (left: Path, right: Path) -> Bool {
		switch (left, right) {
		case (.node(_,_,_), .node(_,_,_)) where left.totalWeight < right.totalWeight: return true
		case (.end, .end): return true
		default: return false
		}
	}
}

