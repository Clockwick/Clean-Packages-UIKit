//
//  File.swift
//  Domain
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation

public protocol MatrixRepository {
  func create(_ matrix: Matrix) async throws
  func fetch(id: String) async throws -> Matrix
  func fetchAll() async throws -> [Matrix]
  func update(_ matrix: Matrix) async throws
  func delete(id: String) async throws
}
