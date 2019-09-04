//
//  ViewController.swift
//  HomeScreenVC
//
//  Created by imtiaz abbas on 21/08/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {

  var gameView = GameView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.sv(gameView)
    gameView.setupView()
    gameView.fillContainer()
  }

}
