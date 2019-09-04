//
//  Node.swift
//  ChainReaction
//
//  Created by Able on 04/09/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Foundation
import UIKit

struct Player {
  var name: String
  var color: UIColor
  var playerId: Int
}

struct GameNodeIndex: Hashable {
  var x: Int
  var y: Int
  
  static func == (lhs: GameNodeIndex, rhs: GameNodeIndex) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

struct GameNode {
  var x: Int
  var y: Int
  var threshold: Int
  var playerId: Int
  var currentValue: Int
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
    threshold = 0
    playerId = 0
    currentValue = 0
  }
  
  mutating func with(threshold: Int) -> GameNode {
    self.threshold = threshold
    return self
  }
}
