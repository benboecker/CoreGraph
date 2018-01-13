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
struct Graph<N: Equatable> {
	/// Stores the nodes that build the graph
	fileprivate(set) var nodes: [Node<N>] = []
}


// MARK: - Public methods
extension Graph {
	/**
	Adds a new `Node` object to the node array, containing the value passed in `with`.
	If a `Node` with the given value already exists, this function returns nil.
	
	- Parameter with: The value that will be stored in the new `Node`.
	- Returns: A Result object containing either the newly created `Node` or an error that the node already exists.
	*/
	@discardableResult mutating func addNode(with value: N) -> Result<Node<N>> {
		guard !hasNode(with: value) else { return .unexpected(.nodeAlreadyExists) }
		
		let node = Node<N>(with: value)
		nodes.append(node)
		
		return .expected(node)
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
	mutating func addEdge(from source: N, to destination: N, weight: Double) {
		guard let sourceNode = self[source],
			let destinationNode = self[destination],
			!sourceNode.hasEdge(to: destinationNode)
			else {
				return
		}
		
		sourceNode.addEdge(to: destinationNode, weight: weight)
	}
	
	/**
	Calculates the shortest path between the two given nodes using dijkstra's algorithm.
	
	- Paramater from: The content value of the starting `Node`.
	- Paramater to: The content value of the destination `Node`.
	- Returns: A `Route` object containing the contents of each `Node` on the shortest path and the corresponding distances between each node.
	*/
	func shortestPath(from: N, to: N) -> Result<Route<N>> {
		guard let source = self[from] else {
			return .unexpected(.startingPOINotFound)
		}
		guard let destination = self[to] else {
			return .unexpected(.destinationPOINotFound)
		}
		
		/// Represents the frontier. It is contains all paths along the graph.
		let frontier: Frontier<N> = .init()

		let startingPath: Frontier<N>.Path<N> = Frontier.Path(destination: source)
		startingPath.total = 0
		
		// Contains all paths that are shortest to the destination node of the path
		var finalPaths = [Frontier<N>.Path<N>]()
		
		// Buildung the starting frontier
		for edge in source.edges {
			let newPath = Frontier<N>.Path<N>(destination: edge.destination)
			newPath.total = edge.weight
			newPath.previous = startingPath
			frontier.add(newPath)
		}
		
		// Calculate paths to all nodes while the frontier is not empty
		while !frontier.isEmpty {
			// Finding the current best path, which is the first one.
			let bestPathResult = frontier.getBestPath()
			guard let bestPath = bestPathResult.data else {
				continue
			}
			
			// Removing the best path since it will be added to the final paths.
			// This way, the frontier eventually gets smaller and smaller.
			frontier.remove(bestPath)
			
			// For each edge in the best path, add a new path to the frontier
			for edge in bestPath.destination.edges {
				guard !bestPath.has(node: edge.destination) else {
					continue
				}
				
				let newPath = Frontier<N>.Path<N>(destination: edge.destination)
				newPath.previous = bestPath
				newPath.total = bestPath.total + edge.weight
				
				// Checking if the new path is shorter than the next one in the frontier.
				// If it is, it will be the next best path in the next iteration over the frontier.
//				if let first = frontier.first, newPath.total < first.total {
//					frontier.insert(newPath, at: 0)
//				} else {
//					frontier.append(newPath)
//				}
				
				frontier.add(newPath)
			}
			
			// Adding best path to final paths
			finalPaths.append(bestPath)
			
			// As soon as the destination is found, the algorithm stops
			if bestPath.destination == destination {
				frontier.removeAllPaths()
			}
		}
		
		// Getting the path to the destination node with the lowest total weight
		let path = finalPaths.filter {
			return $0.destination.value == to
			}.sorted { $0.total < $1.total }.first
		
		if let path = path, let route = Route(path: path) {			
			return .expected(route)
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

	/**
	Checks if this graph contains a node that stores the given value.
	This is needed to make sure only unique values are stored in the graph.

	- Parameter with: A value to check for.
	- Returns: A `Bool` indicating whether the graph has a `Node` that contains the given value.
	*/
	func hasNode(with value: N) -> Bool {
		return self[value] != nil
	}
}

// MARK: - Subscripts
extension Graph {
	/**
	Gets the first `Node` object found for the given value content.
 
	- Parameter value: The value to look for in the nodes array.
	- Returns: The `Node?` object that contains the given value or nil if no node contains this value.
	*/
	subscript(value: N) -> Node<N>? {
		get {
			return nodes.filter { $0.value == value }.first
		}
	}
}


extension Graph: CustomStringConvertible {
	var description: String {
		var result = ""
		
		for node in nodes {
			result += "\(node)\n"
		}
		result.removeLast()

		return result
	}
}







