//
//  Graph.swift
//  UniMaps
//
//  Created by Benni on 13.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import Foundation

/**
This class represents the graph used for calculating the shortest path between nodes.
*/
public class Graph<Element: Hashable> {
	/**
	Stores the nodes that build the graph as a dictionary for better performance.
	The nodes are stored as the keys and the edges leading from the nodes are the dictionary values.
	*/
	private(set) var nodes: [Element: [Edge<Element>]] = [:]
	
	public init() {}
}


// MARK: - Public methods
public extension Graph {
	/**
	Adds a new node value to the nodes dictionary, containing the value passed in `with`.
	If a node with the given value already exists, this function returns an unexpected result.
	
	- Parameter with: The value that will be stored in the new node.
	- Returns: A Result object containing either the newly created `Node` or an error that the node already exists.
	*/
	@discardableResult func addNode(with value: Element) -> Result<Element> {
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
	@discardableResult func addEdge(from source: Element, to destination: Element, weight: Double) -> Result<Void> {
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
	Calculates the shortest path in the graph from one node to another using Dijkstra's Algorithm.
	- Parameter from: The source node from where the algorithm calculates the shortest path.
	- Parameter to: The destination node to which the shortest path is calculated to from the source node.
	- Returns: A `Result` value containing either the calculated shortest `Path` or an unexpected error value.
	*/
	func shortestPath(from source: Element, to destination: Element) -> Result<Path<Element>> {
		guard self[source] != nil else {
			return .unexpected(.startingPOINotFound)
		}
		guard self[destination] != nil else {
			return .unexpected(.destinationPOINotFound)
		}
		
		let startingPath = Path.end.append(source, weight: 0.0)
		var openList = [Path<Element>]()
		var eliminatedNodes: Set<Element> = [source]
		
		successorsPaths(for: startingPath).forEach { openList.addSorted($0) }
		
		while !openList.isEmpty {
			let currentPath = openList.removeFirst()
			let currentNode = currentPath.node!

			if currentNode == destination {
				return .expected(currentPath)
			}

			eliminatedNodes.insert(currentNode)
			
			let successorPaths = successorsPaths(for: currentPath)

			for successor in successorPaths where !eliminatedNodes.contains(successor.node!) {
				let index = openList.index(for: successor)
				
				if index < openList.count && openList[index] == successor {
					if successor.totalWeight < openList[index].totalWeight {
						// TODO: Find a test case where this is triggered
						guard let node = openList[index].node else { continue }
						let _path = currentPath.append(node, weight: openList[index].weight)

						openList[index] = _path
					}
				} else {
					openList.insert(successor, at: index)
				}
			}
		}

		return .unexpected(.shortestPathNotFound)
	}
	
	/**
	Removes all nodes from the graph.
	*/
	func clear() {
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
		guard let edges = nodes[node] else { return false }
		
		return edges.contains(where: { edge -> Bool in
			return edge.destination == anotherNode
		})
	}
	
	/**
	Calculates all paths leading from the destination node of a given `Path` value.
	
	**NOTE:** This is responsible for the false distances in the Dijkstra's final result `Path`.
	
	- Parameter for: The `Path` value from which's destination node the resulting paths will be diverged.
	- Returns: An array of diverging `Path` values from the given `Path` value.
	*/
	func successorsPaths(for path: Path<Element>) -> [Path<Element>] {
		guard let _node = path.node, let edges = nodes[_node] else {
			return []
		}
		
		return edges.map { edge in
			return path.append(edge.destination, weight: edge.weight)
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
