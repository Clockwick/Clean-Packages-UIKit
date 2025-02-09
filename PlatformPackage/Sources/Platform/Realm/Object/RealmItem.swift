//
//  RealmItem.swift
//  Platform
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation
import RealmSwift
import Domain

public class RealmItem: Object {
  @Persisted(primaryKey: true) var id: String
  @Persisted var text: String
  @Persisted var isSelected: Bool
  
  public convenience init(item: Item) {
    self.init()
    self.id = item.id
    self.text = item.text
    self.isSelected = item.isSelected
  }
  
  public func toDomain() -> Item {
    Item(id: id, text: text, isSelected: isSelected)
  }
}
