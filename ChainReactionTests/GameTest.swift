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
  
  func testGameBoardCornerItemThreshold() {
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
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
