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
  var chainReactionViewModel: ChainReactionViewModel?
  
  init(chainReactionViewModel: ChainReactionViewModel?) {
    self.chainReactionViewModel = chainReactionViewModel
  }
  func start(onDequeue: @escaping (Int, Int) -> Void) -> Void {
    timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { _ in
      if let n = self.chainReactionViewModel?.explosionQueue.dequeue() {
        onDequeue(n.index.x, n.index.y)
      }
    })
  }
  
  func stop() -> Void {
    timer?.invalidate()
  }
}
