//
//  Route.swift
//  UniMaps
//
//  Created by Benni on 20.05.17.
//  Copyright © 2017 Ben Boecker. All rights reserved.
//

import Foundation

/// A route along a `Graph`. Consists of a array of `Node` content values of type `N` and corresponding distances.
struct Route<N: Equatable> {
	
	/// The waypoints making up the route and the corresponding distances in meters
	let waypoints: [(waypoint: N, distance: Double)]
	
	/// Calculates the total distance of all waypoints
	var totalDistance: Double {
		return waypoints.reduce(0.0) { return $0 + $1.distance }
	}
	
	/// Initializes the Route from a `FrontierPath` object.
	/// - Parameter path: A `FrontierPath` object that is making up the route.
	/// - Returns: Either:
	///    - A `Route` with the waypoints of the given path.
	///    - `nil` when the path's total value is 0 or smaller.
	init?(path: Frontier<N>.Path<N>) {
		guard path.total > 0 else {
			return nil
		}
		
		var waypoints: [(waypoint: N, distance: Double)] = []
		
		var p = path
		let distance = path.total - (path.previous?.total ?? 0)
		waypoints.append((path.destination.value, distance))

		while let current = p.previous {
			let distance = current.total - (current.previous?.total ?? 0)
			waypoints.append((waypoint: current.destination.value, distance: distance))
			p = current
		}
		
		self.waypoints = waypoints.reversed()
	}
}

extension Route: CustomStringConvertible {
	var description: String {		
		return ""
	}
}
