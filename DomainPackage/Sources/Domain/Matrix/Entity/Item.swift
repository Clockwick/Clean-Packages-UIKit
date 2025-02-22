//
//  File.swift
//  Domain
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation

public struct Item: Identifiable, Equatable, Sendable {
  public let id: String
  public var text: String
  public var isDone: Bool
  
  public init(
    id: String = UUID().uuidString,
    text: String,
    isDone: Bool
  ) {
    self.id = id
    self.text = text
    self.isDone = isDone
  }
  
  public static var empty: Item {
    .init(text: "", isDone: false)
  }
}
