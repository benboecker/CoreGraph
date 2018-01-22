//
//  MinimumFirstArray.swift
//  CoreGraph
//
//  Created by Benni on 22.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

struct MinimumHeap<T: Comparable>: ExpressibleByArrayLiteral {
	typealias ArrayLiteralElement = T

	private var heap = [T]()
	
	init(arrayLiteral elements: T...) {
		elements.forEach { add($0) }
	}
}

extension MinimumHeap {
	var isEmpty: Bool {
		return heap.isEmpty
	}
	
	mutating func removeAll() {
		heap.removeAll()
	}
	
	var count: Int {
		return heap.count
	}
	
	mutating func add(_ element: T) {
		heap.append(element)

		var childIndex: Int = heap.count - 1
		var parentIndex: Int = 0

		if childIndex != 0 {
			parentIndex = (childIndex - 1) / 2
		}

		var childToUse: T
		var parentToUse: T

		while childIndex != 0 {
			childToUse = heap[childIndex]
			parentToUse = heap[parentIndex]

			if childToUse < parentToUse {
				heap.swapAt(parentIndex, childIndex)
			}

			childIndex = parentIndex

			if childIndex != 0 {
				parentIndex = (childIndex - 1) / 2
			}
		}
	}
	
	mutating func removeFirst() {
		guard !isEmpty else { return }
		heap.remove(at: 0)
		guard !isEmpty else { return }
		
		heap.insert(heap[count - 1], at: 0)
		heap.remove(at: count - 1)
		
		shiftDown(from: 0)
	}
	
	var first: T? {
		return heap.first
	}
	
	subscript(index: Int) -> T {
		get {
			return heap[index]
		}
	}
}

private extension MinimumHeap {
	
	mutating func shiftDown(from parentIndex: Int) {
		let leftIndex = (parentIndex * 2) + 1
		let rightIndex = leftIndex + 1
		let count = heap.count
		guard parentIndex < count, leftIndex < count else { return }
		
		let parent = heap[parentIndex]
		let leftChild = heap[leftIndex]

		if rightIndex < count {
			let rightChild = heap[rightIndex]
			
			if leftChild < rightChild, leftChild < parent {
				heap.swapAt(leftIndex, parentIndex)
				shiftDown(from: leftIndex)
			}
			if rightChild < leftChild, rightChild < parent {
				heap.swapAt(rightIndex, parentIndex)
				shiftDown(from: rightIndex)
			}
		} else if leftChild < parent {
			heap.swapAt(leftIndex, parentIndex)
			shiftDown(from: leftIndex)
		}
	}
}


extension MinimumHeap: CustomStringConvertible {
	var description: String {
		return "\(heap)"
	}
}


