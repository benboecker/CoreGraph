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
Internally the values are stored in an array, and are shifted on insertion and deletion
to always have the smallest element in the first position. This guarantees an access
time of `O(n)` for the smallest element and `O(log(n))` when inserting or deleting an element.

The `MinHeap` struct is generic over a `Comparable` data type and may be initialized from an array,
putting the smallest value of the array in the first place.
*/
struct MinHeap<T: Comparable>: ExpressibleByArrayLiteral {
	/// Typealias for conforming to `ExpressibleByArrayLiteral`.
	typealias ArrayLiteralElement = T

	/// Internal array storing the heap values.
	private var heap = [T]()
	
	/// Initializer for conforming to `ExpressibleByArrayLiteral`.
	init(arrayLiteral elements: T...) {
		elements.forEach { add($0) }
	}
}

// MARK: - Internal methods and properties
extension MinHeap {
	/// Indicates whether the heap contains any values or not.
	var isEmpty: Bool {
		return heap.isEmpty
	}
	
	/// This function removes all elements from the heap.
	mutating func removeAll() {
		heap.removeAll()
	}
	
	/// The total number of elements in the heap.
	var count: Int {
		return heap.count
	}
	
	/**
	This function adds an element to the heap.
	It first is added to the end of the internal array, then shifted forwards
	until it reaches its place in the heap structure.
	
	- Parameter element: The element to be added to the heap.
	*/
	mutating func add(_ element: T) {
		heap.append(element)
		
		shiftUp(from: count - 1)
	}
	
	/**
	This funtion removes the smallest element from the heap which is the element
	at the first index in the internal array. The last element then gets put in front of
	the array and then shifted down until the minimum heap requirements are fulfilled again.
	
	- Returns: The removed element or nil if the heap is empty.
	*/
	@discardableResult mutating func remove() -> T? {
		guard !isEmpty else { return nil }
		let element = heap.remove(at: 0)
		guard !isEmpty else { return element }
		
		heap.insert(heap[count - 1], at: 0)
		heap.remove(at: count - 1)
		
		shiftDown(from: 0)
		return element
	}
	
	/**
	The smallest element in the heap, which is the first one in the internal array.
	If the heap is empty, nil is returned.
	*/
	var minimum: T? {
		return heap.first
	}

	/**
	This function shifts a value upwards from a given index position by swapping it with its
	parent value. The next shift is called recursively until the minimum heap requirement is fulfilled.
	
	- Parameter from: The index from which the shifting upwards should begin.
	*/
	mutating func shiftUp(from childIndex: Int) {
		let parentIndex = (childIndex - 1) / 2
		
		let child = heap[childIndex]
		
		if child < heap[parentIndex] {
			heap.swapAt(childIndex, parentIndex)
			shiftUp(from: parentIndex)
		}
	}
	
	/**
	This function shifts a value down in the heap from a given index by swapping it with the smaller
	child element. The next shift is called recursively until the minimum heap requirements are fulfilled.
	*/
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
	
	/// Internal subscript for easy access of the heap values in the internal array.
	subscript(index: Int) -> T {
		get {
			return heap[index]
		}
	}
}
