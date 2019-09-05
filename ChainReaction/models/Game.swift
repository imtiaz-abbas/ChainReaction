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
    // todo
  }
  
  func end() {
    // todo
  }
  
  func handleGameOperation(operation: GameOperation) -> Void {
    switch operation {
    case .tap(let playerId, let node):
      tapAction(playerId: playerId, node: node)
    case .undo:
      undoAction()
    case .redo:
      redoAction()
    }
  }
  
  fileprivate func constructAdjacencyNodes() {
    let maxX = board.x
    let maxY = board.y
    
    for x in 0...maxX-1 {
      for y in 0...maxY-1 {
        let gameNodeIndex = GameNodeIndex(x: x, y: y)
        
        let top = gameNodes[GameNodeIndex(x: x - 1, y: y)]
        let bottom = gameNodes[GameNodeIndex(x: x + 1, y: y)]
        let right = gameNodes[GameNodeIndex(x: x, y: y + 1)]
        let left = gameNodes[GameNodeIndex(x: x, y: y - 1)]
        
        var directions: Array<Direction> = []
        
        if (x > 0 && y > 0 && x < maxX - 1 && y < maxY - 1) {
          directions.append(.up)
          directions.append(.down)
          directions.append(.left)
          directions.append(.right)
        } else if (x == 0 && y != 0 && y != maxY - 1) {
          directions.append(.down)
          directions.append(.right)
          directions.append(.left)
        } else if (y == 0 && x != 0 && x != maxX - 1) {
          directions.append(.up)
          directions.append(.down)
          directions.append(.right)
        } else if(x == maxX - 1 && y != 0 && y != maxY - 1) {
          directions.append(.up)
          directions.append(.right)
          directions.append(.left)
        } else if(y == maxY - 1 && x != 0 && x != maxX - 1) {
          directions.append(.up)
          directions.append(.down)
          directions.append(.left)
        } else if (x == 0 && y == 0) {
          directions.append(.down)
          directions.append(.right)
        } else if (x == maxX - 1 && y == maxY - 1) {
          directions.append(.up)
          directions.append(.left)
        } else if (x == maxX - 1 && y == 0) {
          directions.append(.up)
          directions.append(.right)
        } else if (x == 0 && y == maxY - 1) {
          directions.append(.down)
          directions.append(.left)
        }
        var nodeList: NodeList = []
        if directions.contains(.up) && top != nil {
          nodeList.append(top!)
        }
        if directions.contains(.down) && bottom != nil {
          nodeList.append(bottom!)
        }
        if directions.contains(.right) && right != nil {
          nodeList.append(right!)
        }
        if directions.contains(.left) && left != nil {
          nodeList.append(left!)
        }
        gameNodes[gameNodeIndex] = gameNodes[gameNodeIndex]?.with(directions: directions)
        gameNodeGraph[gameNodeIndex] = nodeList
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



// GameOperation action methods
extension Game {
  
  private func tapAction(playerId: Int, node: GameNode) -> Void {
    var mutableNode = node
    if mutableNode.currentValue == mutableNode.threshold {
      var nodeWithPlayer = mutableNode.with(playerId: 0)
      gameNodes[GameNodeIndex(x: mutableNode.x, y: mutableNode.y)] = nodeWithPlayer.with(currentValue: 0)
    } else {
      var nodeWithPlayer = mutableNode.with(playerId: playerId)
      gameNodes[GameNodeIndex(x: mutableNode.x, y: mutableNode.y)] = nodeWithPlayer.with(currentValue: mutableNode.currentValue + 1)
    }
  }
  
  private func undoAction() {
    // todo undo
  }
  
  private func redoAction() {
    // todo redo
  }
}
