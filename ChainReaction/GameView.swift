//
//  GameView.swift
//  ChainReaction
//
//  Created by imtiaz abbas on 21/08/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Foundation
import Stevia
import UIKit

class GameView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  var collectionView: UICollectionView!
  let screenSize = UIScreen.main.bounds
  
  var chainReactionViewModel: ChainReactionViewModel? = nil
  var gameBuilder = GameBuilder()
  var game: Game?
  var gameLoop: GameLoop?
  
  let x = 15
  let y = 8
  
  func setupView() {
    let game = gameBuilder.with(size: Gameboard(x: self.x, y: self.y)).addPlayer(withName: "Player1", color: .red).addPlayer(withName: "Player2", color: .yellow).build()
    self.game = game
    game.start()
    
    chainReactionViewModel = ChainReactionViewModel(x: x, y: y)
    chainReactionViewModel?.startGame()
    
    gameLoop = GameLoop(chainReactionViewModel: chainReactionViewModel)
    gameLoop?.start { (i, j) in
      let c = self.collectionView.cellForItem(at: IndexPath(row: i * self.y + j, section: 0)) as! GridItemCollectionViewCell
//      c.explode()
    }
    
    
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
    return game!.board.x * game!.board.y
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: screenSize.width / 8, height: screenSize.width / 8)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionView", for: indexPath) as! GridItemCollectionViewCell
    cell.setupView(node: game?.gameNodes[GameNodeIndex(x: Int(indexPath.row / y), y: indexPath.row % y)], chainReactionViewModel: chainReactionViewModel)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! GridItemCollectionViewCell
    cell.didSelect()
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
      collectionView.reloadData()
    }
  }
  
}

class GridItemCollectionViewCell: UICollectionViewCell {
  
  var node: GameNode?
  var lab = UILabel()
  var chainReactionViewModel: ChainReactionViewModel?
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView(node: GameNode?, chainReactionViewModel: ChainReactionViewModel?) {
    self.node = node
    self.chainReactionViewModel = chainReactionViewModel
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.borderWidth = 1
    self.backgroundColor = .black
    
    self.sv(lab)
    lab.text = "\(node!.currentValue)"
    lab.textAlignment = .center
    lab.centerVertically().centerHorizontally()
    lab.textColor = .white
    
    self.layer.zPosition = 50
  }
  
  func didSelect() {
    
//    chainReactionViewModel?.userSelected(x: node!.index.x, y: node!.index.y)
//    lab.text = "\(node!.currentValue)"
  }
//
//  func explode() {
//    if node?.directions.contains(.up) ?? false {
//      let v = UIView()
//      self.sv(v)
//      v.centerHorizontally().centerVertically().height(16).width(16)
//      v.layer.cornerRadius = 8
//      v.layer.masksToBounds = true
//      v.backgroundColor = .white
//      UIView.animate(withDuration: 0.7, animations: {
//        v.transform = CGAffineTransform(translationX: 0, y: -50)
//      }) { _ in
//        v.removeFromSuperview()
//      }
//    }
//
//    if node?.directions.contains(.down) ?? false {
//      let v = UIView()
//      self.sv(v)
//      v.centerHorizontally().centerVertically().height(16).width(16)
//      v.layer.cornerRadius = 8
//      v.layer.masksToBounds = true
//      v.backgroundColor = .white
//
//      UIView.animate(withDuration: 0.7, animations: {
//        v.transform = CGAffineTransform(translationX: 0, y: 50)
//      }) { _ in
//        v.removeFromSuperview()
//      }
//    }
//    if node?.directions.contains(.right) ?? false {
//      let v = UIView()
//      self.sv(v)
//      v.centerHorizontally().centerVertically().height(16).width(16)
//      v.layer.cornerRadius = 8
//      v.layer.masksToBounds = true
//      v.backgroundColor = .white
//      UIView.animate(withDuration: 0.7, animations: {
//       v.transform = CGAffineTransform(translationX: 50, y: 0)
//      }) { _ in
//        v.removeFromSuperview()
//      }
//
//    }
//    if node?.directions.contains(.left) ?? false {
//      let v = UIView()
//      self.sv(v)
//      v.centerHorizontally().centerVertically().height(16).width(16)
//      v.layer.cornerRadius = 8
//      v.layer.masksToBounds = true
//      v.backgroundColor = .white
//      UIView.animate(withDuration: 0.7, animations: {
//        v.transform = CGAffineTransform(translationX: -50, y: 0)
//      }) { _ in
//        v.removeFromSuperview()
//      }
//    }
//  }
//
}
