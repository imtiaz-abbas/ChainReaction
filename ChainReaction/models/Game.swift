//
//  File.swift
//  ChainReaction
//
//  Created by Able on 04/09/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Foundation
import UIKit

typealias NodeList = Array<GameNode>
typealias Gameboard = GameNodeIndex
typealias PlayerID = Int

class GameBuilder {
  var game = Game()
  
  func with(size gameSize: Gameboard) -> GameBuilder {
    game.board = gameSize
    return self
  }
  
  func addPlayer(withName name: String, color: UIColor) -> GameBuilder{
    let playerId = game.players.count
    game.players[playerId] = Player(name: name, color: color, playerId: playerId)
    return self
  }
  
  
  func build() -> Game {
    game.constuctBoard()
    game.constructAdjacencyNodes()
    game.currentPlayer = game.players.first?.value.playerId ?? 0
    return self.game
  }
}

enum GameOperation {
  case tap(playerId: PlayerID, node: GameNode)
  case undo
  case redo
}

enum GameState {
  case waitingForPlayer(playerId: PlayerID)
  case performingPlayerOperation(playerId: PlayerID)
}

class Game {
  var board: Gameboard = GameNodeIndex(x: 4, y: 4)
  var gameNodes: [GameNodeIndex: GameNode] = [:]
  var gameNodeGraph: [GameNodeIndex: NodeList] = [:]
  var state: GameState?
  
  var players: [PlayerID: Player] = [:]
  var currentPlayer: PlayerID = 0
  var numberOfPlayers: Int {
    return players.count
  }
  
  func start() {
    print("PLAYER ID IS", currentPlayer)
  }
  
  func end() {
    
  }
  
  func handleGameOperation(operation: GameOperation) -> Void {
//    switch operation {
//    case .tap(var playerId, var node):
//      break
//    case .undo:
//      break
//    case .redo:
//      break
//    }
  }
  
  
  fileprivate func constructAdjacencyNodes() {
    let maxX = board.x
    let maxY = board.y
    
    for x in 0...maxX-1 {
      for y in 0...maxY-1 {
        var top: GameNode? = nil
        var bottom: GameNode? = nil
        var right: GameNode? = nil
        var left: GameNode? = nil
        if (x > 0 && y > 0 && x < maxX - 1 && y < maxY - 1) {
          top = GameNode(x: x - 1, y: y)
          bottom = GameNode(x: x + 1, y: y)
          right = GameNode(x: x, y: y + 1)
          left = GameNode(x: x, y: y - 1)
        } else if (x == 0 && y != 0 && y != maxY - 1) {
          bottom = GameNode(x: x + 1, y: y)
          right = GameNode(x: x, y: y + 1)
          left = GameNode(x: x, y: y - 1)
        } else if (y == 0 && x != 0 && x != maxX - 1) {
          top = GameNode(x: x - 1, y: y)
          bottom = GameNode(x: x + 1, y: y)
          right = GameNode(x: x, y: y + 1)
        } else if(x == maxX - 1 && y != 0 && y != maxY - 1) {
          top = GameNode(x: x - 1, y: y)
          right = GameNode(x: x, y: y + 1)
          left = GameNode(x: x, y: y - 1)
        } else if(y == maxY - 1 && x != 0 && x != maxX - 1) {
          top = GameNode(x: x - 1, y: y)
          bottom = GameNode(x: x + 1, y: y)
          left = GameNode(x: x, y: y - 1)
        } else if (x == 0 && y == 0) {
          bottom = GameNode(x: x + 1, y: y)
          right = GameNode(x: x, y: y + 1)
        } else if (x == maxX - 1 && y == maxY - 1) {
          top = GameNode(x: x - 1, y: y)
          left = GameNode(x: x, y: y - 1)
        } else if (x == maxX - 1 && y == 0) {
          top = GameNode(x: x - 1, y: y)
          right = GameNode(x: x, y: y + 1)
        } else if (x == 0 && y == maxY - 1) {
          bottom = GameNode(x: x + 1, y: y)
          left = GameNode(x: x, y: y - 1)
        }
        var nodeList: NodeList = []
        if (top != nil) {
          nodeList.append(top!)
        }
        if (bottom != nil) {
          nodeList.append(bottom!)
        }
        if (right != nil) {
          nodeList.append(right!)
        }
        if (left != nil) {
          nodeList.append(left!)
        }
        gameNodeGraph[GameNodeIndex(x: x, y: y)] = nodeList
      }
    }
  }
  
  fileprivate func constuctBoard() {
    let maxX = board.x - 1
    let maxY = board.y - 1
    for i in 0...maxX {
      for j in 0...maxY {
        var t = 0
        if ((i == 0 && j == 0) || (i == 0 && j == maxY) || (i == maxX && j == 0) || (i == maxX && j == maxY)) {
          t = 1
        } else if (i == 0 || j == 0 || i == maxX || j == maxY) {
          t = 2
        } else {
          t = 3
        }
        var gameNode = GameNode(x: i, y: j)
        gameNodes[GameNodeIndex(x: i, y: j)] = gameNode.with(threshold: t)
      }
    }
  }
}
