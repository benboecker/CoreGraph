//
//  UniMapsError.swift
//  UniMaps
//
//  Created by Benni on 07.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

//protocol UniMapsError: Error {
//
//}
//
//enum UserFacingError: UniMapsError {
//
//}

enum CoreGraphError: Error {
	
	case nodeAlreadyExists
	case shortestPathNotFound
	case startingPOINotFound
	case destinationPOINotFound
}
