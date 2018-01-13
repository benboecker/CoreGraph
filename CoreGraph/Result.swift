//
//  Result.swift
//  UniMaps
//
//  Created by Benni on 07.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation


enum Result<T> {
	case expected(T)
	case unexpected(GraphError)
}

extension Result {
	var isExpected: Bool {
		switch self {
		case .expected(_): return true
		case .unexpected(_): return false
		}
	}
	
	var isUnexpected: Bool {
		return !isExpected
	}
	
	var data: T? {
		if case .expected(let data) = self {
			return data
		} else {
			return nil
		}
	}
	
	var error: GraphError? {
		if case .unexpected(let error) = self {
			return error
		} else {
			return nil
		}
	}
	
	func onExpected(_ callback: (T) -> Void) {
		if case .expected(let data) = self {
			callback(data)
		}
	}
	
	func onUnexpected(_ callback: (GraphError) -> Void) {
		if case .unexpected(let error) = self {
			callback(error)
		}
	}
}
