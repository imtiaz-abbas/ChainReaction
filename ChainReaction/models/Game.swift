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


enum GameOperation {
  case tap(playerId: PlayerID, node: GameNode)
  case undo
  case redo
}

enum GameOperationResult {
  case tapResult(treeLevelList: Array<NodeList>?)
  case none
}

enum GameState: Equatable {
  case initial
  case waitingForPlayer(playerId: PlayerID)
  case performingPlayerOperation
}

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

class Game {
  var board: Gameboard = GameNodeIndex(x: 4, y: 4)
  var gameNodes: [GameNodeIndex: GameNode] = [:]
  var prevGameNodes: [GameNodeIndex: GameNode] = [:]
  var redoGameNodes: [GameNodeIndex: GameNode] = [:]
  var gameNodeGraph: [GameNodeIndex: NodeList] = [:]
  var explosionQueue: GameNodeQueue = GameNodeQueue<NodeList>()
  var state: GameState = .initial
  
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
  
  func handleGameOperation(operation: GameOperation) -> GameOperationResult {
    switch operation {
    case .tap(let playerId, let node):
      let selectedNode = gameNodes[GameNodeIndex(x: node.x, y: node.y)]!
      if state == .performingPlayerOperation || (selectedNode.currentValue > 0 && selectedNode.playerId != playerId) {
        return .none
      }
      let treeLevelList = tapAction(playerId: playerId, node: node)
      treeLevelList?.enumerated().forEach({ (index, val) in
        explosionQueue.enqueue(element: val)
      })
      self.checkPlayerOperationCompletion()
      return .tapResult(treeLevelList: treeLevelList)
    case .undo:
      undoAction()
      return .none
    case .redo:
      redoAction()
      return .none
    }
  }
  
  var playerOperationTimer: Timer?
  func checkPlayerOperationCompletion() {
    playerOperationTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
      if self.explosionQueue.isEmpty() {
        self.nextPlayer()
        self.state = .waitingForPlayer(playerId: self.currentPlayer)
        self.invalidatePlayerOperationTimer()
      }
    }
  }
  
  func invalidatePlayerOperationTimer() {
    playerOperationTimer?.invalidate()
  }
  
  func nextPlayer() {
    if self.currentPlayer == players.count - 1 {
      self.currentPlayer = 0
    } else {
      self.currentPlayer += 1
    }
  }
  
  func prevPlayer() -> Void {
    if self.currentPlayer == 0 {
      self.currentPlayer = players.count - 1
    } else {
      self.currentPlayer -= 1
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


class TreeNode {
  var node: GameNode = GameNode(x: 0, y: 0)
  var parent: TreeNode?
  var children: [TreeNode] = []
}

struct GameNodeWithParent {
  var node: GameNode
  var parent: TreeNode?
}

struct TreeNodeWithLevel {
  var node: TreeNode
  var level: Int
}



// GameOperation action methods
extension Game {
  
  private func tapAction(playerId: Int, node: GameNode) -> Array<NodeList>? {
    var nodeQueue: GameNodeQueue = GameNodeQueue<GameNodeWithParent>()
    
    self.prevGameNodes = gameNodes
    self.state = .performingPlayerOperation
    
    nodeQueue.enqueue(element: GameNodeWithParent(node: node, parent: nil))
    var treeRoot : TreeNode?
    while !nodeQueue.isEmpty() {
      if let dequeuedNode = nodeQueue.dequeue() {
        let nodeIndex = GameNodeIndex(x: dequeuedNode.node.x, y: dequeuedNode.node.y)
        if gameNodes[nodeIndex]?.currentValue == gameNodes[nodeIndex]?.threshold {
          var treeNode:TreeNode?
          if(treeRoot == nil) {
            treeRoot = TreeNode()
            treeRoot?.node = dequeuedNode.node
            treeRoot?.children = []
            treeRoot?.parent = nil
            treeNode = treeRoot
          } else {
            treeNode = TreeNode()
            treeNode?.node = dequeuedNode.node
            treeNode?.children = []
            treeNode?.parent = dequeuedNode.parent
            dequeuedNode.parent?.children.append(treeNode!)
          }
          gameNodes[nodeIndex]?.currentValue = 0
          gameNodes[nodeIndex]?.playerId = -1
          gameNodeGraph[nodeIndex]?.forEach({ adjacentNode in
            nodeQueue.enqueue(element: GameNodeWithParent(node: adjacentNode, parent: treeNode))
          })
        } else {
          if let gNode = gameNodes[nodeIndex] {
            gameNodes[nodeIndex]!.currentValue = gNode.currentValue + 1
            gameNodes[nodeIndex]!.playerId = playerId
          }
        }
      }
    }
    if let treeR = treeRoot {
      return walkTree(treeNode: treeR)
    }
    return []
  }
  
  
  func walkTree(treeNode: TreeNode) -> Array<NodeList> {
    var queue = GameNodeQueue<TreeNodeWithLevel>()
    var arrToReturn: Array<NodeList> = []
    queue.enqueue(element: TreeNodeWithLevel(node: treeNode, level: 0))
    while !queue.isEmpty() {
      if let tNode = queue.dequeue() {
//        print("Node: \(tNode.node.node.x) \(tNode.node.node.y) : Level \(tNode.level)")
        
        if arrToReturn.count <= tNode.level {
          arrToReturn.insert([tNode.node.node], at: tNode.level)
        } else {
          var l = arrToReturn[tNode.level]
          l.append(tNode.node.node)
          arrToReturn[tNode.level] = l
        }
        tNode.node.children.forEach { (child) in
          queue.enqueue(element: TreeNodeWithLevel(node: child, level: tNode.level + 1))
        }
      }
    }
    return arrToReturn
  }
  
  private func undoAction() {
    if !prevGameNodes.isEmpty {
      redoGameNodes = gameNodes
      gameNodes = prevGameNodes
      prevGameNodes = [:]
      prevPlayer()
    }
  }
  
  private func redoAction() {
    if !redoGameNodes.isEmpty {
      prevGameNodes = gameNodes
      gameNodes = redoGameNodes
      redoGameNodes = [:]
      nextPlayer()
    }
  }
}

struct GameNodeQueue<T> {
  var nodes:[T] = []
  
  mutating func enqueue(element: T) {
    nodes.append(element)
  }
  
  mutating func dequeue() -> T? {
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
