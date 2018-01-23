//
//  MinimumFirstArray.swift
//  CoreGraph
//
//  Created by Benni on 22.01.18.
//  Copyright © 2018 Ben Boecker. All rights reserved.
//

import Foundation

/**
This struct represents a minimum heap.
*/
struct MinHeap<T: Comparable>: ExpressibleByArrayLiteral {
	typealias ArrayLiteralElement = T

	private var heap = [T]()
	
	init(arrayLiteral elements: T...) {
		elements.forEach { add($0) }
	}
}

extension MinHeap {
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

		shiftUp(from: heap.count - 1)
	}
	
	mutating func remove() {
		guard !isEmpty else { return }
		heap.remove(at: 0)
		guard !isEmpty else { return }
		
		heap.insert(heap[count - 1], at: 0)
		heap.remove(at: count - 1)
		
		shiftDown(from: 0)
	}
	
	func peek() -> T? {
		return heap.first
	}
	
	subscript(index: Int) -> T {
		get {
			return heap[index]
		}
	}
}

private extension MinHeap {
	mutating func shiftUp(from childIndex: Int) {
		let parentIndex = (childIndex - 1) / 2
		
		let child = heap[childIndex]
		
		if child < heap[parentIndex] {
			heap.swapAt(childIndex, parentIndex)
			shiftUp(from: parentIndex)
		}
	}
	
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


extension MinHeap: CustomStringConvertible {
	var description: String {
		return "\(heap)"
	}
}


