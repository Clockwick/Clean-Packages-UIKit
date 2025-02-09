//
//  File.swift
//  Domain
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation

public struct MatrixItem: Identifiable, Equatable {
  public let id: String
  public var items: [Item]
  
  public init(
    id: String = UUID().uuidString,
    items: [Item]
  ) {
    self.id = id
    self.items = items
  }
}
