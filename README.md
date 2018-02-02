# CoreGraph

Core Graph is a framework for creating a generic, bidirectional and weighted graph consisting of nodes and edges. It’s also able to find the shortest path between two nodes using a simple Dijkstra algorithm. It is written in Swift 4 using Xcode 9.2. It is fully documented and provides unit tests with a complex graph.

## Installation
Clone the repository and add the project file to the *Linked Frameworks and Libraries* section in your target’s general options. Press the plus button and then the *Add other* button to select the *CoreGraph* project file. It will be added to your project in a separate *Frameworks* group.

![Linked Frameworks](https://raw.githubusercontent.com/benboecker/CoreGraph/master/readme_images/linked_frameworks.png)
![Add other](https://raw.githubusercontent.com/benboecker/CoreGraph/master/readme_images/add_other.png)

Add the framework to the *Embedded Binaries* section in your target’s general options, selecting the framework file from the just added *CoreGraph* project.

![Embedded Binaries](https://raw.githubusercontent.com/benboecker/CoreGraph/master/readme_images/embedded_binaries.png)
![Select Framework](https://raw.githubusercontent.com/benboecker/CoreGraph/master/readme_images/select_framework.png)

## Usage

In the source file where you want to use the graph, import the CoreGraph framework:

```
import CoreGraph
```

### `Graph<Element: Hashable>`
Instantiate a graph with a constrained type that must implement the `Hashable` protocol.

```
var graph = Graph<String>()
```

A `Graph` is a struct, meaning that if you want to add nodes to it you have to declare it as a `var`. You can add nodes via the `addNode(with: _)` function, that returns a `Result<Element>` value, telling you if the node was added to the graph or if something went wrong. For example if the node already exists in the graph, the result will be unexpected and gives you an `nodeAlreadyExists` error. The result is discardable and doesn't have to be used.

```
let result = graph.addNode(with: "A")
result.onExpected { node in
	print(node) // "A"
}

graph.addNode(with: "B") // no warning
```

You add edges from one node to another with the `addEdge(from: _, to: _, weight: _)` function. This also returns a `Result` that gives you insight about possible errors. An edge doesn't get added twice for example. Again, this result is discardable.

```
let result = graph.addEdge(from: "A", to: "B", weight: 20.0)
print(result.isExpected) // true

let wrong = graph.addEdge(from: "A", to: "B", weight: 30.0)
print(result.error!) // .edgeAlreadyExists
```

The shortest path between two nodes is calculated with a Dijkstra algorithm.

```
var shortestPathResult = graph.shortestPath(from: "A", to: "B")
```

Again, this uses a `Result` type to tell you if the algorithm found a shortest path or if something went wrong.

```
shortestPathResult.onExpected { path in
	print("\(path)") // [A] -20.0- [B]
}

shortestPathResult = graph.shortestPath(from: "A", to: "C")
print(shortestPathresult.error!) // .destinationNodeNotFound
```

The `Graph` also has a function to remove all nodes and edges from it.

```
graph.clear()
```

### `Path<Element: Equatable>`
The expected result from the graph`s `shortestPath` function is a `Path` value that is generic over the node type of the graph. It is implemented as a linked list `enum`, meaning that one segment hold some data and points to the next until it reaches its end.

The public interface of a path has two properties:

`nodeData: [(Element, Double)]`

This is the actual path data with the nodes along the path and the distances to them from the previous node. This means, that the first distance is always 0. In the eample from above this would look like this:

```
print(path.nodeData) // [("A", 0.0), ("B", 20.0)]
```

This way you can build up the route the way you like to.

The second property is the total distance of the path, which simply adds up the distances from the `nodeData` property.

```
print(path.totalWeight) // 20.0
```







