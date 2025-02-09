//
//  File.swift
//  Domain
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation

public struct Item: Identifiable, Equatable {
  public let id: String
  public var text: String
  public var isSelected: Bool
  
  public init(
    id: String = UUID().uuidString,
    text: String,
    isSelected: Bool
  ) {
    self.id = id
    self.text = text
    self.isSelected = isSelected
  }
}
