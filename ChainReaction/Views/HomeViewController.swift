//
//  HomeViewController.swift
//  ChainReaction
//
//  Created by Able on 06/09/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import UIKit
import Stevia

class HomeViewController: UIViewController {
  
  var gameViewController: GameViewController = GameViewController()
  var titleLabel: UILabel = UILabel()
  var contentView: UIView = UIView()
  var twoPlayerButton: UIButton = UIButton(type: .system)
  var threePlayerButton: UIButton = UIButton(type: .system)
  var fourPlayerButton: UIButton = UIButton(type: .system)
  var fivePlayerButton: UIButton = UIButton(type: .system)
  var sixPlayerButton: UIButton = UIButton(type: .system)
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.sv(contentView)
    
    contentView.Top == self.view.safeAreaLayoutGuide.Top
    contentView.Bottom == self.view.safeAreaLayoutGuide.Bottom
    contentView.Left == self.view.safeAreaLayoutGuide.Left
    contentView.Right == self.view.safeAreaLayoutGuide.Right
    contentView.backgroundColor = .black
    
    contentView.sv(titleLabel)
    titleLabel.centerHorizontally()
    titleLabel.Top == contentView.Top + 50
    titleLabel.text = "Chain Reaction"
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    titleLabel.font = titleLabel.font.withSize(25)
    
    contentView.sv(twoPlayerButton, threePlayerButton, fourPlayerButton, fivePlayerButton, sixPlayerButton)
    
    twoPlayerButton.text("2 Players")
    twoPlayerButton.Top == titleLabel.Bottom + 100
    twoPlayerButton.centerHorizontally()
    twoPlayerButton.addTarget(self, action: #selector(twoPlayerAction), for: .touchUpInside)
    
    threePlayerButton.text("3 Players")
    threePlayerButton.Top == twoPlayerButton.Bottom + 20
    threePlayerButton.centerHorizontally()
    threePlayerButton.addTarget(self, action: #selector(threePlayerAction), for: .touchUpInside)
    
    fourPlayerButton.text("4 Players")
    fourPlayerButton.Top == threePlayerButton.Bottom + 20
    fourPlayerButton.centerHorizontally()
    fourPlayerButton.addTarget(self, action: #selector(fourPlayerAction), for: .touchUpInside)
    
    fivePlayerButton.text("5 Players")
    fivePlayerButton.Top == fourPlayerButton.Bottom + 20
    fivePlayerButton.centerHorizontally()
    fivePlayerButton.addTarget(self, action: #selector(fivePlayerAction), for: .touchUpInside)
    
    sixPlayerButton.text("6 Players")
    sixPlayerButton.Top == fivePlayerButton.Bottom + 20
    sixPlayerButton.centerHorizontally()
    sixPlayerButton.addTarget(self, action: #selector(sixPlayerAction), for: .touchUpInside)
  }
  
  @objc func twoPlayerAction(button: UIButton) {
    gameViewController.setNumOfPlayers(players: 2)
    self.present(gameViewController, animated: true, completion: nil)
  }
  
  @objc func threePlayerAction(button: UIButton) {
    gameViewController.setNumOfPlayers(players: 3)
    self.present(gameViewController, animated: true, completion: nil)
  }
  
  @objc func fourPlayerAction(button: UIButton) {
    gameViewController.setNumOfPlayers(players: 4)
    self.present(gameViewController, animated: true, completion: nil)
  }
  
  @objc func fivePlayerAction(button: UIButton) {
    gameViewController.setNumOfPlayers(players: 5)
    self.present(gameViewController, animated: true, completion: nil)
  }
  
  @objc func sixPlayerAction(button: UIButton) {
    gameViewController.setNumOfPlayers(players: 6)
    self.present(gameViewController, animated: true, completion: nil)
  }
}
