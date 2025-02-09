//
//  File.swift
//  Platform
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation
import RealmSwift
import Domain

public class RealmMatrix: Object {
  @Persisted(primaryKey: true) var id: String
  @Persisted var timestamp: String
  @Persisted var importantUrgent: RealmMatrixItem?
  @Persisted var importantNonUrgent: RealmMatrixItem?
  @Persisted var nonImportantUrgent: RealmMatrixItem?
  @Persisted var nonImportantNonUrgent: RealmMatrixItem?
  
  public convenience init(matrix: Matrix) {
    self.init()
    self.id = matrix.id
    self.timestamp = matrix.timestamp
    self.importantUrgent = RealmMatrixItem(matrixItem: matrix.importantUrgent)
    self.importantNonUrgent = RealmMatrixItem(matrixItem: matrix.importantNonUrgent)
    self.nonImportantUrgent = RealmMatrixItem(matrixItem: matrix.nonImportantUrgent)
    self.nonImportantNonUrgent = RealmMatrixItem(matrixItem: matrix.nonImportantNonUrgent)
  }
  
  public func toDomain() throws -> Matrix {
    guard let importantUrgent = importantUrgent,
          let importantNonUrgent = importantNonUrgent,
          let nonImportantUrgent = nonImportantUrgent,
          let nonImportantNonUrgent = nonImportantNonUrgent else {
      throw MatrixDomainError.invalidData
    }
    
    return Matrix(
      id: id,
      timestamp: timestamp,
      importantUrgent: importantUrgent.toDomain(),
      importantNonUrgent: importantNonUrgent.toDomain(),
      nonImportantUrgent: nonImportantUrgent.toDomain(),
      nonImportantNonUrgent: nonImportantNonUrgent.toDomain()
    )
  }
}
