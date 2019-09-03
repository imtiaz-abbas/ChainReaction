//
//  GridCollectionView.swift
//  ChainReaction
//
//  Created by imtiaz abbas on 21/08/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Foundation
import Stevia
import UIKit

class GridCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  var collectionView: UICollectionView!
  let screenSize = UIScreen.main.bounds
  
  func setupView() {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSize(width: screenSize.width / 10, height: screenSize.width / 10)
    self.collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
    sv(collectionView)
    collectionView.Top == safeAreaLayoutGuide.Top
    collectionView.Bottom == safeAreaLayoutGuide.Bottom
    
    collectionView.fillHorizontally()
    self.collectionView.register(GridItemCollectionViewCell.self, forCellWithReuseIdentifier: "GridCollectionView")
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    self.collectionView.allowsSelection = true
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 120
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: screenSize.width / 8, height: screenSize.width / 8)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionView", for: indexPath) as! GridItemCollectionViewCell
    cell.setupView(indexPath: indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! GridItemCollectionViewCell
    cell.didSelect()
  }
  
}

class GridItemCollectionViewCell: UICollectionViewCell {
  var indexPath: Int? = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView(indexPath: IndexPath) {
    self.indexPath = indexPath.row
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.borderWidth = 1
    self.backgroundColor = .black
  }
  
  func didSelect() {
    var v = UIView()
    self.sv(v)
    v.height(26).width(26).centerVertically().centerHorizontally()
    v.layer.cornerRadius = 13
    v.layer.masksToBounds = true
    v.backgroundColor = .yellow
  }
  
}
