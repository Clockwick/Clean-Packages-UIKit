//
//  File.swift
//  Platform
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation
import RealmSwift
import Domain

public struct MatrixItemMapper {
  public static func mapToDomain(_ realmMatrixItem: RealmMatrixItem) -> MatrixItem {
    MatrixItem(
      id: realmMatrixItem.id,
      items: Array(realmMatrixItem.items).toDomain()
    )
  }
  
  public static func mapToRealm(_ matrixItem: MatrixItem) -> RealmMatrixItem {
    let realmMatrixItem = RealmMatrixItem()
    realmMatrixItem.id = matrixItem.id
    realmMatrixItem.items.append(objectsIn: matrixItem.items.toRealm())
    return realmMatrixItem
  }
  
  public static func updateRealmMatrixItem(_ realmMatrixItem: RealmMatrixItem, with matrixItem: MatrixItem) {
    // Clear existing items
    realmMatrixItem.items.removeAll()
    
    // Add new items
    realmMatrixItem.items.append(objectsIn: matrixItem.items.toRealm())
  }
  
  public static func updateItems(_ realmMatrixItem: RealmMatrixItem, with items: [Item]) {
    realmMatrixItem.items.removeAll()
    realmMatrixItem.items.append(objectsIn: items.toRealm())
  }
}

extension Array where Element == RealmMatrixItem {
  func toDomain() -> [MatrixItem] {
    map(MatrixItemMapper.mapToDomain)
  }
}

extension Array where Element == MatrixItem {
  func toRealm() -> [RealmMatrixItem] {
    map(MatrixItemMapper.mapToRealm)
  }
}
