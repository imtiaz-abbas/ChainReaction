//
//  Any+Extensions.swift
//  ChainReaction
//
//  Created by Able on 05/09/19.
//  Copyright © 2019 imtiaz abbas. All rights reserved.
//

import Foundation


extension Dictionary where Value: Any {
  static func != (left: [Key : Value], right: [Key : Value]) -> Bool { return !(left == right) }
  static func == (left: [Key : Value], right: [Key : Value]) -> Bool {
    if left.count != right.count { return false }
    for element in left {
      guard   let rightValue = right[element.key],
        areEqual(rightValue, element.value) else { return false }
    }
    return true
  }
}

func areEqual (_ left: Any, _ right: Any) -> Bool {
  if  type(of: left) == type(of: right) &&
    String(describing: left) == String(describing: right) { return true }
  if let left = left as? [Any], let right = right as? [Any] { return left == right }
  if let left = left as? [AnyHashable: Any], let right = right as? [AnyHashable: Any] { return left == right }
  return false
}

extension Array where Element: Any {
  static func != (left: [Element], right: [Element]) -> Bool { return !(left == right) }
  static func == (left: [Element], right: [Element]) -> Bool {
    if left.count != right.count { return false }
    var right = right
    loop: for leftValue in left {
      for (rightIndex, rightValue) in right.enumerated() where areEqual(leftValue, rightValue) {
        right.remove(at: rightIndex)
        continue loop
      }
      return false
    }
    return true
  }
}
