//
//  NodeModel.swift
//  ChainReaction
//
//  Created by Able on 03/09/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Foundation


struct NodeIndex {
  var x: Int = 0
  var y: Int = 0
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

class Node {
  var threshold: Int
  var index: NodeIndex
  var currentValue: Int = 0
  var adjacencyList: Array<Node> = []
  
  init(x: Int, y: Int) {
    self.threshold = 3
    self.index = NodeIndex(x: x, y: y)
  }
  
  func handleThresholdReached( queue: inout NodeQueue) {
    currentValue = 0
    queue.enqueue(element: self)
    for i in adjacencyList {
      i.addOne(queue: &queue)
    }
  }
  
  func addOne(queue: inout NodeQueue) {
    if currentValue == threshold {
      handleThresholdReached(queue: &queue)
    } else {
      currentValue += 1
    }
  }
  
}
