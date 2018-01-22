//
//  Frontier.swift
//  UniMaps
//
//  Created by Benni on 09.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation



class Frontier<N: Equatable> {
	var paths = MinimumHeap<Path<N>>()
}

// MARK: - Public methods and properties
extension Frontier {
	var isEmpty: Bool {
		return paths.isEmpty
	}
	
	func removeAllPaths() {
		paths.removeAll()
	}
	
	func getBestPath() -> Result<Path<N>> {
		guard !isEmpty else { return .unexpected(.frontierIsEmpty) }

		return .expected(paths[0])
	}
	
	func add(_ path: Path<N>) {
		paths.add(path)
	}
	
	@discardableResult func removeBestPath() -> Result<Int> {
		guard !paths.isEmpty else {
			return .unexpected(GraphError.elementNotRemoved)
		}
		paths.removeFirst()
		
		return .expected(0)
	}
}


extension Frontier {
	class Path<N: Equatable> {
	
		/// The total weight of this path. Default value is `infinity` for calculating the shortest path
		// in the dijkstra algorithm (The best path is always shorter than infinity).
		var total: Double = Double.infinity
		/// The destination `Node` of the path.
		var destination: Node<N>
		/// Previous path segment. `Nil` if no segment preceeds this one.
		var previous: Path?
		
		/// The node content values that make up this path.
		var nodeValues: [N] {
			var result: [N] = [self.destination.value]
			var p = self
			
			while let current = p.previous {
				result.append(current.destination.value)
				p = current
			}
			
			return result
		}
		
		/**
		Initializer that takes a node object and sets it as the destination.
		
		- Parameter destination: The `Node` object that will become the destination
		of this path. Defaults to a new `Node` object.
		- Parameter previous: The `Path` object that precedes this path part.
		Defaults to nil, which is the end of the path.
		*/
		init (destination: Node<N>, previous: Path<N>? = nil) {
			self.destination = destination
			self.previous = previous
		}
		
		/**
		Checks if a given `Node` appears somewhere in the path.
		
		- Parameter node: The `Node` to check for
		- Returns: `true` if the node lies somewhere on the path, `false` if not.
		*/
		func has(node: Node<N>) -> Bool {
			if destination == node {
				return true
			} else {
				return previous?.has(node: node) ?? false
			}
		}
	}
}

// MARK: - Frontier CustomStringConvertible
extension Frontier: CustomStringConvertible {
	var description: String {
		return ""
		//return paths.map { "\($0)" }.joined(separator: "\n")
	}
}

// MARK: - Frontier.Path CustomStringConvertible
extension Frontier.Path: CustomStringConvertible {
	var description: String {
		return "\(total)"
//		guard let p = previous else {
//			return "[\(destination.value)]"
//		}
//
//		return "[\(destination.value)] — \(String(describing: p))"
	}
}

// MARK: - Frontier.Path Equatable
extension Frontier.Path: Equatable {
	static func ==(left: Frontier.Path<N>, right: Frontier.Path<N>) -> Bool {
		return left.total == right.total && left.destination == right.destination
	}
}

// MARK: - Frontier.Path Comparable
extension Frontier.Path: Comparable {
	static func < (left: Frontier.Path<N>, right: Frontier.Path<N>) -> Bool {
		return left.total < right.total
	}
}

