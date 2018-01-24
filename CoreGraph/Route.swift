//
//  Route.swift
//  UniMaps
//
//  Created by Benni on 20.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import Foundation

/// A route along a `Graph`. Consists of a array of content values of type `N` and corresponding distances between the waypoints.
public struct Route {
	
	/// The waypoints making up the route and the corresponding distances in meters
	public let waypoints: [(waypoint: Int, distance: Double)]
	
	/// Calculates the total distance of all waypoints
	public var totalDistance: Double {
		return waypoints.reduce(0.0) { return $0 + $1.distance }
	}
	
	/// Initializes the Route from a `Frontier.Path` object.
	/// - Parameter path: A `Frontier.Path` object that is making up the route.
	/// - Returns: Either:
	///    - A `Route` with the waypoints of the given path.
	///    - `nil` when the path's total value is 0 or smaller.
	internal init?(path: Frontier.Path) {
		guard path.totalWeight > 0 && path.totalWeight != Double.infinity else {
			return nil
		}
		
		var waypoints: [(waypoint: Int, distance: Double)] = []
		var p = path
		let distance = path.totalWeight - (path.previous?.totalWeight ?? 0)
		waypoints.append((path.destination!.value, distance))

		while let current = p.previous, current != .end {
			let distance = current.totalWeight - (current.previous?.totalWeight ?? 0)
			waypoints.append((waypoint: current.destination!.value, distance: distance))
			p = current
		}
		
		self.waypoints = waypoints.reversed()
	}
	
	/// Hiding the default initializer from outside the framework.
	internal init() {
		self.waypoints = []
	}
}

extension Route: CustomStringConvertible {
	public var description: String {
		return "[\(waypoints.first!.waypoint)]" + waypoints.dropFirst().map { " —\($0.distance)— [\($0.waypoint)]" }.joined()
	}
}
