//
//  ChainReactionViewModel.swift
//  ChainReaction
//
//  Created by Able on 03/09/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Foundation


struct NodeQueue {
  var nodes:[Node] = []
  
  mutating func enqueue(element: Node) {
    nodes.append(element)
  }
  
  mutating func dequeue() -> Node? {
    if nodes.isEmpty {
      return nil
    }
    else{
      let tempElement = nodes.first
      nodes.remove(at: 0)
      return tempElement
    }
  }
  
  func isEmpty() -> Bool {
    return nodes.isEmpty
  }
}

class ChainReactionViewModel {
  var matrix: Array<Array<Node>> = []
  var maxX: Int = 5
  var maxY: Int = 5
  var explosionQueue: NodeQueue = NodeQueue()
  
  init(x: Int, y: Int) {
    maxX = x
    maxY = y
  }
  
  func startGame() {
    constuctMatrix()
    constructAdjacencyList()
  }
  
  func userSelected(x: Int, y: Int) {
    matrix[x][y].addOne(queue: &explosionQueue)
  }
  
  private func constructAdjacencyList() {
    for x in 0...maxX-1 {
      for y in 0...maxY-1 {
        var top: Node? = nil
        var bottom: Node? = nil
        var right: Node? = nil
        var left: Node? = nil
        if (x > 0 && y > 0 && x < maxX - 1 && y < maxY - 1) {
          top = matrix[x - 1][y]
          bottom = matrix[x + 1][y]
          right = matrix[x][y + 1]
          left = matrix[x][y - 1]
        } else if (x == 0 && y != 0 && y != maxY - 1) {
          bottom = matrix[x + 1][y]
          right = matrix[x][y + 1]
          left = matrix[x][y - 1]
        } else if (y == 0 && x != 0 && x != maxX - 1) {
          top = matrix[x - 1][y]
          bottom = matrix[x + 1][y]
          right = matrix[x][y + 1]
        } else if(x == maxX - 1 && y != 0 && y != maxY - 1) {
          top = matrix[x - 1][y]
          right = matrix[x][y + 1]
          left = matrix[x][y - 1]
        } else if(y == maxY - 1 && x != 0 && x != maxX - 1) {
          top = matrix[x - 1][y]
          bottom = matrix[x + 1][y]
          left = matrix[x][y - 1]
        } else if (x == 0 && y == 0) {
          bottom = matrix[x + 1][y]
          right = matrix[x][y + 1]
        } else if (x == maxX - 1 && y == maxY - 1) {
          top = matrix[x - 1][y]
          left = matrix[x][y - 1]
        } else if (x == maxX - 1 && y == 0) {
          top = matrix[x - 1][y]
          right = matrix[x][y + 1]
        } else if (x == 0 && y == maxY - 1) {
          bottom = matrix[x + 1][y]
          left = matrix[x][y - 1]
        }
        if (top != nil) {
          matrix[x][y].adjacencyList.append(top!)
          matrix[x][y].directions.append(.up)
        }
        if (bottom != nil) {
          matrix[x][y].adjacencyList.append(bottom!)
          matrix[x][y].directions.append(.down)
        }
        if (right != nil) {
          matrix[x][y].adjacencyList.append(right!)
          matrix[x][y].directions.append(.right)
        }
        if (left != nil) {
          matrix[x][y].adjacencyList.append(left!)
          matrix[x][y].directions.append(.left)
        }
      }
    }
  }
  
  private func constuctMatrix() {
    for i in 0...maxX {
      var temp: Array<Node> = []
      for j in 0...maxY {
        let n = Node(x: i, y: j)
        if ((i == 0 && j == 0) || (i == 0 && j == maxY - 1) || (i == maxX - 1 && j == 0) || (i == maxX - 1 && j == maxY - 1)) {
          n.threshold = 1
        } else if (i == 0 || j == 0 || i == maxX - 1 || j == maxY - 1) {
          n.threshold = 2
        } else {
          n.threshold = 3
        }
        temp.append(n)
      }
      matrix.append(temp)
    }
  }
}
