//
//  GameLoop.swift
//  ChainReaction
//
//  Created by Able on 04/09/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Foundation

class GameLoop {
  var timer: Timer?
  var game: Game?
  
  init(game: Game?) {
    self.game = game
  }
  func start(onDequeue: @escaping (GameNode) -> Void) -> Void {
    timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
      if let nodeList = self.game?.explosionQueue.dequeue() {
        nodeList.forEach({ (node) in
          onDequeue(node)
        })
      }
    })
  }
  
  func stop() -> Void {
    timer?.invalidate()
  }
}
