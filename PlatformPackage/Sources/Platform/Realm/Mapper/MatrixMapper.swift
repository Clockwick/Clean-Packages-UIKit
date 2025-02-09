//
//  File.swift
//  Platform
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation
import Domain

public struct MatrixMapper {
  public static func mapToDomain(_ realmMatrix: RealmMatrix) throws -> Matrix {
    guard let importantUrgent = realmMatrix.importantUrgent,
          let importantNonUrgent = realmMatrix.importantNonUrgent,
          let nonImportantUrgent = realmMatrix.nonImportantUrgent,
          let nonImportantNonUrgent = realmMatrix.nonImportantNonUrgent else {
      throw MatrixDomainError.invalidData
    }
    
    return Matrix(
      id: realmMatrix.id,
      timestamp: realmMatrix.timestamp,
      importantUrgent: MatrixItemMapper.mapToDomain(importantUrgent),
      importantNonUrgent: MatrixItemMapper.mapToDomain(importantNonUrgent),
      nonImportantUrgent: MatrixItemMapper.mapToDomain(nonImportantUrgent),
      nonImportantNonUrgent: MatrixItemMapper.mapToDomain(nonImportantNonUrgent)
    )
  }
  
  public static func mapToRealm(_ matrix: Matrix) -> RealmMatrix {
    let realmMatrix = RealmMatrix()
    realmMatrix.id = matrix.id
    realmMatrix.timestamp = matrix.timestamp
    realmMatrix.importantUrgent = MatrixItemMapper.mapToRealm(matrix.importantUrgent)
    realmMatrix.importantNonUrgent = MatrixItemMapper.mapToRealm(matrix.importantNonUrgent)
    realmMatrix.nonImportantUrgent = MatrixItemMapper.mapToRealm(matrix.nonImportantUrgent)
    realmMatrix.nonImportantNonUrgent = MatrixItemMapper.mapToRealm(matrix.nonImportantNonUrgent)
    return realmMatrix
  }
}
