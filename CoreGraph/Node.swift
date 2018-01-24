//
//  Node.swift
//  UniMaps
//
//  Created by Benjamin Boecker on 13.05.17.
//  Copyright © 2017 Benjamin Boecker. All rights reserved.


import Foundation

/**
Class to represent a node in the undirected graph used in the dijkstra algorithm.
This class stores it's value as a generic parameter that has the requirement to conform to the `Equatable` protocol
*/
struct Node {
	/// Represents the value stored in the node. Must conform to `Equatable`.
	fileprivate(set) var value: Int
	/// Represents the edges from this node to other nodes.
	fileprivate(set) var edges: [Edge] = []
	
	/**
	This initializer sets the value stored in the node to the given parameter.
	
	- Parameter value: A value of type `Int`, representing the value stored in the node.
	*/
	init(with value: Int) {
		self.edges = []
		self.value = value
	}
}


// MARK: - Public methods
extension Node {
	/**
	Adds a new `Edge` from this node to the destination node with the given weight.
	As we are in a undirected graph, a second `Edge` is created from the destination to `self`.
	
	- Parameter to: A `Node` object that the new edge connects to.
	- Parameter weight: An `Int` indicating the weight of the new node.
	*/
	mutating func addEdge(to destination: Node, weight: Double) {
		let edge = Edge(to: destination, weight: weight)
		edges.append(edge)
	}
	
	
}

// MARK: - Internal methods
extension Node {
	/**
	Checks if the node has a connection to another given `Node`.
	
	- Parameter to: The `Node` to which the connection should be checked.
	- Returns: A Bool that indicates if the node has an edge to the given node.
	*/
	func hasEdge(to node: Int) -> Bool {
		return edges.filter { return $0.destination.value == node }.count > 0
	}
	
	/**
	Gets the specific connection to another `Node` object, if it has any.
	
	- Parameter to: The `Node` to which the connection should be serached for.
	- Returns: A `Result` value containing either the expected `Edge` object or an unexpected `GraphError`.
	*/
	func edge(to node: Node) -> Result<Edge> {
		guard hasEdge(to: node.value),
			let edge = edges.filter({ $0.destination == node }).first else {
				return .unexpected(.edgeNotFound)
		}
		
		return .expected(edge)
	}
}

// MARK: - CustomStringConvertible
extension Node: CustomStringConvertible {
	var description: String {
		var result = "N[\(String(describing: value))]"
		
		for edge in edges {
			result += "\n\t\(edge)"
		}
		
		return result
	}
}

// MARK: - Equatable
extension Node: Equatable {
	static func ==(left: Node, right: Node) -> Bool {
		return left.value == right.value
	}
}


// MARK: - Hashable
extension Node: Hashable {
	var hashValue: Int {
		return self.value.hashValue
	}
}
