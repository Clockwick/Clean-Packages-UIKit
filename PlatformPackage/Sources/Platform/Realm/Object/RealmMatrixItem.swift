//
//  File.swift
//  Platform
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation
import RealmSwift
import Domain

public class RealmMatrixItem: Object {
  @Persisted(primaryKey: true) var id: String
  @Persisted var items: List<RealmItem>
  
  public convenience init(matrixItem: MatrixItem) {
    self.init()
    self.id = matrixItem.id
    self.items.append(objectsIn: matrixItem.items.map(RealmItem.init))
  }
  
  public func toDomain() -> MatrixItem {
    MatrixItem(
      id: id,
      items: items.map { $0.toDomain() }
    )
  }
}
