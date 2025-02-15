//
//  ItemMapper.swift
//  Platform
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation
import RealmSwift
import Domain

public struct ItemMapper {
  public static func mapToDomain(_ realmItem: RealmItem) -> Item {
    Item(
      id: realmItem.id,
      text: realmItem.text,
      isDone: realmItem.isDone
    )
  }
  
  public static func mapToRealm(_ item: Item) -> RealmItem {
    let realmItem = RealmItem()
    realmItem.id = item.id
    realmItem.text = item.text
    realmItem.isDone = item.isDone
    return realmItem
  }
  
  public static func updateRealmItem(_ realmItem: RealmItem, with item: Item) {
    realmItem.text = item.text
    realmItem.isDone = item.isDone
  }
}

extension Array where Element == RealmItem {
  func toDomain() -> [Item] {
    map(ItemMapper.mapToDomain)
  }
}

extension Array where Element == Item {
  func toRealm() -> [RealmItem] {
    map(ItemMapper.mapToRealm)
  }
}
