//
//  Matrix.swift
//  Domain
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation

public struct Matrix: Identifiable, Equatable {
  public let id: String
  public let timestamp: String
  public var importantUrgent: MatrixItem
  public var importantNonUrgent: MatrixItem
  public var nonImportantUrgent: MatrixItem
  public var nonImportantNonUrgent: MatrixItem
  
  public init(
    id: String = UUID().uuidString,
    timestamp: String,
    importantUrgent: MatrixItem,
    importantNonUrgent: MatrixItem,
    nonImportantUrgent: MatrixItem,
    nonImportantNonUrgent: MatrixItem
  ) {
    self.id = id
    self.timestamp = timestamp
    self.importantUrgent = importantUrgent
    self.importantNonUrgent = importantNonUrgent
    self.nonImportantUrgent = nonImportantUrgent
    self.nonImportantNonUrgent = nonImportantNonUrgent
  }
}
