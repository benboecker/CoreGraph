//
//  UniMapsError.swift
//  UniMaps
//
//  Created by Benni on 07.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation



enum GraphError: Error {
	case nodeAlreadyExists
	case shortestPathNotFound
	case startingPOINotFound
	case destinationPOINotFound
	case bestPathNotFound
	case frontierIsEmpty
	case elementNotRemoved
}
