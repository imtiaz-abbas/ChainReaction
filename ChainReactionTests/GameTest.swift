//
//  GameTest.swift
//  ChainReaction
//
//  Created by Able on 04/09/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import XCTest
@testable import ChainReaction
class GameTest: XCTestCase {
  override func setUp() {
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testBuildGame() {
    let gameBuilder = GameBuilder().with(size: Gameboard(x: 4, y: 4))
      .addPlayer(withName: "Player1", color: .red)
      .addPlayer(withName: "Player2", color: .yellow)
    let game = gameBuilder.build()
    XCTAssertEqual(game.numberOfPlayers, 2)
  }
  
  func testGameBoard() {
    let gameBuilder = GameBuilder().with(size: Gameboard(x: 4, y: 4))
      .addPlayer(withName: "Player1", color: .red)
      .addPlayer(withName: "Player2", color: .yellow)
    let game = gameBuilder.build()
    
    XCTAssertEqual(game.gameNodes.count, 16)
  }
  
  func testGameBoardCornerNodesThreshold() {
    let gameBuilder = GameBuilder().with(size: Gameboard(x: 4, y: 4))
      .addPlayer(withName: "Player1", color: .red)
      .addPlayer(withName: "Player2", color: .yellow)
    let game = gameBuilder.build()
    
    game.start()
    
    XCTAssertEqual(game.gameNodes[GameNodeIndex(x: 0, y: 0)]?.threshold, 1)
    XCTAssertEqual(game.gameNodes[GameNodeIndex(x: 3, y: 0)]?.threshold, 1)
    XCTAssertEqual(game.gameNodes[GameNodeIndex(x: 0, y: 3)]?.threshold, 1)
    XCTAssertEqual(game.gameNodes[GameNodeIndex(x: 3, y: 3)]?.threshold, 1)
  }
  
  func testGameBoardNodesThreshold() {
    let sizeX = 4
    let sizeY = 4
    let gameBuilder = GameBuilder().with(size: Gameboard(x: sizeX, y: sizeY))
      .addPlayer(withName: "Player1", color: .red)
      .addPlayer(withName: "Player2", color: .yellow)
    let game = gameBuilder.build()
    
    game.start()
    
    for i in 0...sizeX - 1 {
      for j in 0...sizeY - 1 {
        if ((i == 0 && j == 0) || (i == 0 && j == sizeY - 1) || (i == sizeX - 1 && j == 0) || (i == sizeX - 1 && j == sizeY - 1)) {
          XCTAssertEqual(game.gameNodes[GameNodeIndex(x: i, y: j)]?.threshold, 1)
        } else if (i == 0 || j == 0 || i == sizeX - 1 || j == sizeY - 1) {
          XCTAssertEqual(game.gameNodes[GameNodeIndex(x: i, y: j)]?.threshold, 2)
        } else {
          XCTAssertEqual(game.gameNodes[GameNodeIndex(x: i, y: j)]?.threshold, 3)
        }
      }
    }
    
  }
  
  func testGameBoardAdjacentNodes() {
    let sizeX = 4
    let sizeY = 4
    let gameBuilder = GameBuilder().with(size: Gameboard(x: sizeX, y: sizeY))
      .addPlayer(withName: "Player1", color: .red)
      .addPlayer(withName: "Player2", color: .yellow)
    let game = gameBuilder.build()
    
    game.start()
  }
  
  func testCornerNodeTapAction() {
    let sizeX = 4
    let sizeY = 4
    let gameBuilder = GameBuilder().with(size: Gameboard(x: sizeX, y: sizeY))
      .addPlayer(withName: "Player1", color: .red)
      .addPlayer(withName: "Player2", color: .yellow)
    let game = gameBuilder.build()
    
    game.start()
    game.handleGameOperation(operation: .tap(playerId: game.currentPlayer, node: game.gameNodes[GameNodeIndex(x: 0, y: 0)]!))
    XCTAssertEqual(game.gameNodes[GameNodeIndex(x: 0, y: 0)]?.currentValue, 1)
    
    game.handleGameOperation(operation: .tap(playerId: game.currentPlayer, node: game.gameNodes[GameNodeIndex(x: 0, y: 0)]!))
    XCTAssertEqual(game.gameNodes[GameNodeIndex(x: 0, y: 0)]?.currentValue, 0)
  }
  
  
  func testCornerNodeTapAdjacencyAction() {
    let sizeX = 4
    let sizeY = 4
    let gameBuilder = GameBuilder().with(size: Gameboard(x: sizeX, y: sizeY))
      .addPlayer(withName: "Player1", color: .red)
      .addPlayer(withName: "Player2", color: .yellow)
    let game = gameBuilder.build()
    
    game.start()
    game.handleGameOperation(operation: .tap(playerId: game.currentPlayer, node: game.gameNodes[GameNodeIndex(x: 0, y: 0)]!))
    XCTAssertEqual(game.gameNodes[GameNodeIndex(x: 0, y: 0)]?.currentValue, 1)
    
    game.handleGameOperation(operation: .tap(playerId: game.currentPlayer, node: game.gameNodes[GameNodeIndex(x: 0, y: 0)]!))
    XCTAssertEqual(game.gameNodes[GameNodeIndex(x: 0, y: 0)]?.currentValue, 0)
  }
  
  func testGameBoardNodeExplosionDirections() {
    
    let sizeX = 4
    let sizeY = 4
    let gameBuilder = GameBuilder().with(size: Gameboard(x: sizeX, y: sizeY))
      .addPlayer(withName: "Player1", color: .red)
      .addPlayer(withName: "Player2", color: .yellow)
    let game = gameBuilder.build()
    
    game.start()
    
    for x in 0...sizeX-1 {
      for y in 0...sizeY-1 {
        let gameNodeIndex = GameNodeIndex(x: x, y: y)
        var directions: Array<Direction> = []
        
        if (x > 0 && y > 0 && x < sizeX - 1 && y < sizeY - 1) {
          directions.append(.up)
          directions.append(.down)
          directions.append(.left)
          directions.append(.right)
        } else if (x == 0 && y != 0 && y != sizeY - 1) {
          directions.append(.down)
          directions.append(.right)
          directions.append(.left)
        } else if (y == 0 && x != 0 && x != sizeX - 1) {
          directions.append(.up)
          directions.append(.down)
          directions.append(.right)
        } else if(x == sizeX - 1 && y != 0 && y != sizeY - 1) {
          directions.append(.up)
          directions.append(.right)
          directions.append(.left)
        } else if(y == sizeY - 1 && x != 0 && x != sizeX - 1) {
          directions.append(.up)
          directions.append(.down)
          directions.append(.left)
        } else if (x == 0 && y == 0) {
          directions.append(.down)
          directions.append(.right)
        } else if (x == sizeX - 1 && y == sizeY - 1) {
          directions.append(.up)
          directions.append(.left)
        } else if (x == sizeX - 1 && y == 0) {
          directions.append(.up)
          directions.append(.right)
        } else if (x == 0 && y == sizeY - 1) {
          directions.append(.down)
          directions.append(.left)
        }
        
        XCTAssertEqual(directions, game.gameNodes[gameNodeIndex]?.directions)
      }
    }
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
