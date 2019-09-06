//
//  ViewController.swift
//  HomeScreenVC
//
//  Created by imtiaz abbas on 21/08/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Stevia
import UIKit

class HomeScreenVC: UIViewController {

  var gameView = GameView()
  var buttonsView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.sv(gameView, buttonsView)
    gameView.setupView()
    gameView.fillHorizontally()
    gameView.Top == self.view.Top
    gameView.Bottom == self.view.Bottom - 80
    
    
    buttonsView.Top == gameView.Bottom
    buttonsView.fillHorizontally()
    buttonsView.Bottom == self.view.Bottom
    buttonsView.backgroundColor = .black
    
    
    let undoButton: UIButton = UIButton(type: .system)
    let redoButton: UIButton = UIButton(type: .system)
    
    buttonsView.sv(undoButton, redoButton)
    undoButton.Left == buttonsView.Left + 25
    undoButton.centerVertically()
    undoButton.text("UNDO")
    undoButton.addTarget(self, action: #selector(undoAction), for: .touchUpInside)
    
    redoButton.Right == buttonsView.Right - 25
    redoButton.centerVertically()
    redoButton.text("REDO")
    redoButton.addTarget(self, action: #selector(redoAction), for: .touchUpInside)
    
  }
  
  @objc func undoAction(sender: UIButton!) {
    _ = gameView.game?.handleGameOperation(operation: .undo)
    gameView.reloadData()
  }
  
  @objc func redoAction(sender: UIButton!) {
    _ = gameView.game?.handleGameOperation(operation: .redo)
    gameView.reloadData()
  }

}
