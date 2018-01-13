//
//  Frontier.swift
//  UniMaps
//
//  Created by Benni on 09.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation



class Frontier<N: Equatable> {
	var paths: [Path<N>] = []
	
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
		
		var bestPath = paths.first!
		for path in paths {
			if path < bestPath {
				bestPath = path
			}
		}		
		
		return .expected(bestPath)
	}
	
	func add(_ path: Path<N>) {
		paths.append(path)
	}
	
	@discardableResult func remove(_ path: Path<N>) -> Result<Int> {
		return paths.remove(object: path)
	}
}




extension Frontier {
	class Path<N: Equatable> {
		/// The total weight of this path. Default value is `infinity` for calculating the shortest path in the dijkstra algorithm (The best path is always shorter than infinity).
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
			
			return result.reversed()
		}
		
		/**
		Initializer that takes a node object and sets it as the destination.
		
		- Parameter destination: The `Node` object that will become the destination of this path. Defaults to a new `Node` object.
		*/
		init (destination: Node<N>) {
			self.destination = destination
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

extension Frontier.Path: Equatable {
	static func ==(left: Frontier.Path<N>, right: Frontier.Path<N>) -> Bool {
		return left.total == right.total && left.destination == right.destination
	}
}


extension Frontier.Path: Comparable {
	static func < (left: Frontier.Path<N>, right: Frontier.Path<N>) -> Bool {
		return left.total < right.total
	}
}
