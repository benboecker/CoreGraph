//
//  Graph.swift
//  UniMaps
//
//  Created by Benni on 13.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import Foundation

/**
This struct represents the graph used for calculating the shortest path between nodes.
*/
public struct Graph<Element: Hashable> {
	/// Stores the nodes that build the graph
	private(set) var nodes: [Element: [Edge<Element>]] = [:]
	
	public init() {}
}


// MARK: - Public methods
public extension Graph {
	/**
	Adds a new `Node` object to the node array, containing the value passed in `with`.
	If a `Node` with the given value already exists, this function returns nil.
	
	- Parameter with: The value that will be stored in the new `Node`.
	- Returns: A Result object containing either the newly created `Node` or an error that the node already exists.
	*/
	@discardableResult mutating func addNode(with value: Element) -> Result<Element> {
		guard nodes[value] == nil else {
			return .unexpected(.nodeAlreadyExists)
		}
		
		nodes[value] = []

		return .expected(value)
	}
	
	/**
	Adds a new `Edge` from the value `from` to the value `to`, given the weight in `weight`.
	As we use a undirected graph, a reverse `Edge` is also created, leading from `to` to `from` with the same weight as the first edge.
	Also, if there already is an `Edge` leading from `from` to `to`, no new edge will be created and the function simply returns.
	This is also the case if no node can be found for the `from` or `to` values.
	
	- Parameter from: A value that should be stored in a node in the graph, acting as the **source** of the new Edge.
	- Parameter to: A value that should be stored in a node in the graph, acting as the **destination** of the new Edge.
	- Parameter weight: The weight of the new edge. This is used for both the new edge and the reversed edge.
	*/
	mutating func addEdge(from source: Element, to destination: Element, weight: Double) {
		guard !node(source, hasEdgeTo: destination),
			!node(destination, hasEdgeTo: source)
			else {
				return
		}
		
		self.nodes[source]?.append(Edge(to: destination, weight: weight))
		self.nodes[destination]?.append(Edge(to: source, weight: weight))
	}
	
	/**
	Calculates the shortest path between the two given nodes using dijkstra's algorithm.
	
	- Paramater from: The content value of the starting `Node`.
	- Paramater to: The content value of the destination `Node`.
	- Returns: A `Route` object containing the contents of each `Node` on the shortest path and the corresponding distances between each node.
	*/
	func shortestPath(from: Element, to: Element, minimum: Int = 100) -> Result<Path<Element>> {
		guard self[from] != nil else {
			return .unexpected(.startingPOINotFound)
		}
		guard self[to] != nil else {
			return .unexpected(.destinationPOINotFound)
		}
		
		/// Represents the frontier. It is contains all paths along the graph.
		let frontier = Frontier<Element>()
		// Contains all paths that are shortest to the destination node of the path
		let finalPaths = Frontier<Element>()

		// The starting path in the frontier.
		let startingPath = Path.node(data: from, weight: 0, previous: .end)
		frontier.add(startingPath)
		
		// Calculate paths to all nodes while the frontier is not empty
		while !frontier.isEmpty {
			// Finding the current best path, which can't be nil.
			guard let bestPath = frontier.getBestPath().data,
				let node = bestPath.destination,
				let edges = nodes[node] else {
					continue
			}
			
			// For each edge in the best path, add a new path to the frontier
			for edge in edges {
				guard !bestPath.contains(edge.destination) else {
					continue
				}
				
				frontier.add(bestPath.prepend(with: edge.destination, weight: edge.weight))
			}
			
			// Removing the best path since it will be added to the final paths if it reaches the destination.
			// This way, the frontier eventually gets smaller and smaller.
			frontier.removeBestPath()
			
			// When the destination is reached, the current best path is added to the final paths array.
			if node == to {
				finalPaths.add(bestPath)
				
				if finalPaths.paths.count >= minimum {
					frontier.removeAllPaths()
				}
			}
		}
		
		// Getting the path to the destination node with the lowest total weight
		if let path = finalPaths.getBestPath().data {
			return .expected(path)
		} else {
			return .unexpected(.shortestPathNotFound)
		}
	}

	/**
	Removes all nodes from the graph.
	*/
	mutating func clear() {
		nodes.removeAll()
	}
}

// MARK: - Internal Methods
extension Graph {
	/**
	Checks if this graph contains a node that stores the given value.
	This is needed to make sure only unique values are stored in the graph.
	
	- Parameter with: A value to check for.
	- Returns: A `Bool` indicating whether the graph has a `Node` that contains the given value.
	*/
	func hasNode(with value: Element) -> Bool {
		return self[value] != nil
	}
	
	func node(_ node: Element, hasEdgeTo anotherNode: Element) -> Bool {
		if self.nodes[node] == nil {
			return false
		} else {
			return nodes[node]?.contains(where: { edge -> Bool in
				return edge.destination == anotherNode
			}) ?? false
		}
	}
}

// MARK: - Subscripts
extension Graph {
	/**
	Gets the first `Node` object found for the given value content.
 
	- Parameter value: The value to look for in the nodes dictionary.
	- Returns: The `Node?` object that contains the given value or nil if no node contains this value.
	*/
	internal subscript(value: Element) -> [Edge<Element>]? {
		get {
			return nodes[value]
		}
	}
}


extension Graph: CustomStringConvertible {
	public var description: String {
		var result = ""
		
		for (node, edges) in nodes {
			result += "\(node)\n"
			for edge in edges {
				result += "\t\(edge)\n"
			}
			result += "\n"
		}
		result.removeLast()

		return result
	}
}








func _measure(_ title: String? = nil, call: () -> Void) {
	let startTime = CACurrentMediaTime()
	call()
	let endTime = CACurrentMediaTime()
	
	print("--------------------------------------------")
	if let title = title {
		print("\(title): Time - \(endTime - startTime)")
	} else {
		print("Time - \(endTime - startTime)")
	}
	print("--------------------------------------------")
}

