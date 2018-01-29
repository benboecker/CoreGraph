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
	/**
	Stores the nodes that build the graph as a dictionary for better performance.
	The nodes are stored as the keys and the edges leading from the nodes are the dictionary values.
	*/
	private(set) var nodes: [Element: [Edge<Element>]] = [:]
}


// MARK: - Public methods
public extension Graph {
	/**
	Adds a new node value to the nodes dictionary, containing the value passed in `with`.
	If a node with the given value already exists, this function returns an unexpected result.
	
	- Parameter with: The value that will be stored in the new node.
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
	Also, if there already is an `Edge` leading from `from` to `to` (or vice versa), no new edge will be created and the function simply returns.
	This is also the case if no node can be found for the `from` or `to` values.
	
	- Parameter from: A value that should be stored in a node in the graph, acting as the **source** of the new Edge.
	- Parameter to: A value that should be stored in a node in the graph, acting as the **destination** of the new Edge.
	- Parameter weight: The weight of the new edge. This is used for both the new edge and the reversed edge.
	*/
	@discardableResult mutating func addEdge(from source: Element, to destination: Element, weight: Double) -> Result<Void> {
		guard !node(source, hasEdgeTo: destination),
			!node(destination, hasEdgeTo: source)
			else {
				return .unexpected(.edgeAlreadyExists)
		}

		self.nodes[source]?.append(Edge(to: destination, weight: weight))
		self.nodes[destination]?.append(Edge(to: source, weight: weight))
		
		return .expected(())
	}
	
	/**
	Calculates the shortest path between the two given nodes using dijkstra's algorithm.
	
	- Parameter from: The value of the starting node.
	- Parameter to: The value of the destination node.
	- Returns: A `Result` value containing either the shortest `Path` value or an unexpected error.
	*/
	func shortestPath(from: Element, to: Element) -> Result<Path<Element>> {
		guard self[from] != nil else {
			return .unexpected(.startingPOINotFound)
		}
		guard self[to] != nil else {
			return .unexpected(.destinationPOINotFound)
		}
		
		/// Represents the frontier. It is contains all paths along the graph.
		var frontier = Frontier<Element>()
		// Contains all paths that are shortest to the destination node of the path
		var finalPaths = Frontier<Element>()

		// The starting path in the frontier.		
		let startingPath = Path.node(data: from, weight: 0, previous: .end)
		frontier.add(startingPath)
		
		// Calculate paths to all nodes while the frontier is not empty
		while !frontier.isEmpty {
			// Finding the current best path, which can't be nil.
			let bestPath = frontier.bestPath.data!
			let node = bestPath.node!
			let edges = nodes[node]!
			
			// For each edge in the best path, add a new path to the frontier
			for edge in edges {
				guard !bestPath.contains(edge.destination) else {
					continue
				}
				
				frontier.add(bestPath.append(edge.destination, weight: edge.weight))
			}
			
			// Removing the best path since it will be added to the final paths if it reaches the destination.
			// This way, the frontier eventually gets smaller and smaller.
			frontier.removeBestPath()
			
			// When the destination is reached, the current best path is added to the final paths array.
			if node == to {
				finalPaths.add(bestPath)
				
//				if finalPaths.paths.count >= 1 {
//					frontier.removeAllPaths()
//				}
			}
		}
		
		// Getting the path to the destination node with the lowest total weight
		if let path = finalPaths.bestPath.data {
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
	Checks if this graph contains a node that has an `Edge` to another given node.
	This is needed to make sure only unique values are stored in the graph.
	
	- Parameter node: The source node.
	- Parameter anotherNode: The destination node.
	- Returns: A `Bool` indicating whether the graph has an edge leading from `node` to `anotherNode`.
	*/
	func node(_ node: Element, hasEdgeTo anotherNode: Element) -> Bool {
		if self.nodes[node] == nil {
			return false
		} else {
			return nodes[node]!.contains(where: { edge -> Bool in
				return edge.destination == anotherNode
			})
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
