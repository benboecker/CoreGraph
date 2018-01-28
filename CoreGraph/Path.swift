//
//  Path.swift
//  CoreGraph
//
//  Created by Benni on 24.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

public enum Path<Element: Equatable> {
	case end
	indirect case node(data: Element, weight: Double, previous: Path)
}

extension Path {
	func prepend(with data: Element, weight: Double) -> Path {
		return .node(data: data, weight: weight, previous: self)
	}
	
	func contains(_ element: Element) -> Bool {
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
	
	var destination: Element? {
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
	
	var route: [(Element, Double)] {
		if case let .node(node, weight, previous) = self {
			return [(node, weight)] + previous.route
		} else {
			return []
		}
	}
}

// MARK: - Path CustomStringConvertible
extension Path: CustomStringConvertible {
	public var description: String {
		return route.reversed().map { (node, weight) -> String in
			if weight == 0 {
				return "[\(node)]"
			} else {
				return " —\(weight)— [\(node)]"
			}
		}.joined()
	}
}

// MARK: - Path Equatable
extension Path: Equatable {
	public static func ==(left: Path, right: Path) -> Bool {
		switch (left, right) {
		case (.node(_,_,_), .node(_,_,_)) where left.totalWeight == right.totalWeight: return true
		case (.end, .end): return true
		default: return false
		}
	}
}

// MARK: - Path Comparable
extension Path: Comparable {
	public static func < (left: Path, right: Path) -> Bool {
		switch (left, right) {
		case (.node(_,_,_), .node(_,_,_)) where left.totalWeight < right.totalWeight: return true
		case (.end, .end): return true
		default: return false
		}
	}
}

