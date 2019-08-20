//
//  ViewController.swift
//  HomeScreenVC
//
//  Created by imtiaz abbas on 21/08/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {

  var gridCollectionView = GridCollectionView()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    self.view.sv(gridCollectionView)
    gridCollectionView.setupView()
    gridCollectionView.fillContainer()
  }

}
