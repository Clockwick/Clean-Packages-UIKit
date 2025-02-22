//
//  MatrixUseCase.swift
//  Domain
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import RxSwift
import RxCocoa

public protocol MatrixUseCase {
  var matrices: [Matrix] { get set }
  var currentMatrix: Matrix? { get }
  var currentIndexRelay: BehaviorRelay<Int> { get }
  
  func saveMatrices(_ matrices: [Matrix])
  func updateCurrentMatrix(index: Int)
  
  // Matrix Operations
//   func createMatrix(timestamp: String) async throws -> Matrix
//   func getMatrix(id: String) async throws -> Matrix
//   func getAllMatrices() async throws -> [Matrix]
//   func updateMatrix(_ matrix: Matrix) async throws
//   func deleteMatrix(id: String) async throws
  
  // MatrixItem Operations
  // func updateMatrixItem(_ matrixItem: MatrixItem, in matrix: Matrix, quadrant: MatrixQuadrant) async throws -> Matrix
  
  // Item Operations
  // func addItem(text: String, to matrixItem: MatrixItem, in matrix: Matrix, quadrant: MatrixQuadrant) async throws -> Matrix
  // func updateItem(_ item: Item, in matrixItem: MatrixItem, in matrix: Matrix, quadrant: MatrixQuadrant) async throws -> Matrix
  // func deleteItem(id: String, from matrixItem: MatrixItem, in matrix: Matrix, quadrant: MatrixQuadrant) async throws -> Matrix
  // func toggleItemSelection(id: String, in matrixItem: MatrixItem, in matrix: Matrix, quadrant: MatrixQuadrant) async throws -> Matrix
}
