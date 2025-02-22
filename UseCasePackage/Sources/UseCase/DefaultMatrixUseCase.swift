import Domain
import Repository
import RxSwift
import RxRelay
import RxCocoa
import Utils

public class DefaultMatrixUseCase: MatrixUseCase {
  // MARK: - Public Properties
  public var matrices: [Matrix] = []
  public let currentIndexRelay = BehaviorRelay<Int>(value: 0)
  
  // MARK: - Computed Properties
  public var currentMatrix: Matrix? {
    let currentIndex = currentIndexRelay.value
    guard matrices.indices.contains(currentIndex) else {
      return nil
    }
    return matrices[currentIndex]
  }
  
  public func saveMatrices(_ matrices: [Matrix]) {
    self.matrices = matrices
  }
  
  public func updateCurrentMatrix(index: Int) {
    guard matrices.indices.contains(index) else { return }
    currentIndexRelay.accept(index)
  }
  
  public init() {}
}
