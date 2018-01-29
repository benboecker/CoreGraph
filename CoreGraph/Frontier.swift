//
//  Frontier.swift
//  UniMaps
//
//  Created by Benni on 09.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

/**
This struct represents the concept of a frontier for the Dijkstra algorithm.
It stores `Path` values in a minimum heap structure to always have `O(n)` access to the path with the smallest total weight (meaning shortest total distance).

The `Frontier` is generic over the same generic type of the path values, the ones representing the nodes on a path.
*/
struct Frontier<Element: Equatable> {
	/// All paths in the frontier are stored in this property as a minimum heap. Generic over the frontier's generic value.
	var paths = MinHeap<Path<Element>>()
}

// MARK: - Public methods and properties
extension Frontier {
	/// Indicates whether the frontier currently holds any paths.
	var isEmpty: Bool {
		return paths.isEmpty
	}
	
	/**
	Returns a result type of either:
	- The best path in the frontier, the one with the smalles total weight.
	- A GraphError value of type `.frontierIsEmpty`
	*/
	var bestPath: Result<Path<Element>> {
		guard !isEmpty else { return .unexpected(.frontierIsEmpty) }
		
		return .expected(paths[0])
	}
	
	/**
	If the frontier holds any paths, remove them all from the frontier.
	*/
	mutating func removeAllPaths() {
		if !isEmpty {
			paths.removeAll()
		}
	}
	
	/**
	This function adds a path to the frontier.
	- Parameter path: The path to be added to the frontier's internal minimum heap.
	*/
	mutating func add(_ path: Path<Element>) {
		paths.add(path)
	}
	
	/**
	This function removes the best path from the frontier, which is the first entry in the heap,
	the path with the smallest total weight.
	
	- Returns: A discardable result type of either the path that was removed or an `GraphError.elementNotRemoved` value if the element couldn't be removed.
	*/
	@discardableResult mutating func removeBestPath() -> Result<Path<Element>> {
		guard !paths.isEmpty, let removedPath = paths.remove() else {
			return .unexpected(GraphError.elementNotRemoved)
		}

		return .expected(removedPath)
	}
}
