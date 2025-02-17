//
//  File.swift
//  Domain
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation

public enum MatrixQuadrant {
  case importantUrgent
  case importantNonUrgent
  case nonImportantUrgent
  case nonImportantNonUrgent
  
  public var title: String {
    switch self {
    case .importantUrgent:
      return "Important & Urgent"
    case .importantNonUrgent:
      return "Important & Non-Urgent"
    case .nonImportantUrgent:
      return "Non-Important & Urgent"
    case .nonImportantNonUrgent:
      return "Non-Important & Non-Urgent"
    }
  }
}
