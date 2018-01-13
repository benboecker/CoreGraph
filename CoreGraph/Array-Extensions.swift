//
//  Array-Extensions.swift
//  CoreGraph
//
//  Created by Benni on 10.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
	// Remove first collection element that is equal to the given `object`:
	@discardableResult mutating func remove(object: Element) -> Result<Int> {
		if let index = index(of: object) {
			remove(at: index)
			return .expected(index)
		}
		
		return .unexpected(.elementNotRemoved)
	}
	
	func element(after element: Element) -> Element? {
		guard let index = index(of: element) else {
			return nil
		}
		
		return self[safe: index + 1]
	}
	
	func element(before element: Element) -> Element? {
		guard let index = index(of: element) else {
			return nil
		}
		
		return self[safe: index - 1]
	}
	
	func index(where closure: (Element) -> (Bool)) -> Int? {
		guard let filteredElement = filter(closure).first else {
			return nil
		}
		
		return index(of: filteredElement)
	}
	
	subscript (safe index: Int) -> Element? {
		get {
			guard index >= 0, index < count else {
				return nil
			}
			
			return self[index]
		}
	}
}
