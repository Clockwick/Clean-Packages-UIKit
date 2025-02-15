import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay
import Utils

public class MatrixGridCollectionView: UICollectionView {
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  fileprivate let tapItemRelay = PublishRelay<Int>()
  private let cellColors: [UIColor] = (0..<4).map { _ in
    UIColor(
      red: CGFloat.random(in: 0...1),
      green: CGFloat.random(in: 0...1),
      blue: CGFloat.random(in: 0...1),
      alpha: 1.0
    )
  }
  
  // MARK: - Initialization
  public init() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = .zero
    
    super.init(frame: .zero, collectionViewLayout: layout)
    
    backgroundColor = .white
    delegate = self
    dataSource = self
    isScrollEnabled = false
    register(MatrixGridCell.self, forCellWithReuseIdentifier: MatrixGridCell.reuseID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UICollectionViewDataSource
extension MatrixGridCollectionView: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatrixGridCell", for: indexPath) as! MatrixGridCell
    cell.configure(with: indexPath.item + 1, color: cellColors[indexPath.item])
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MatrixGridCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width / 2
    let height = collectionView.bounds.height / 2
    return CGSize(width: width, height: height)
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    tapItemRelay.accept(indexPath.item)
  }
}

// MARK: - Reactive Extension
public extension Reactive where Base: MatrixGridCollectionView {
  @MainActor
  var itemTapped: Observable<Int> {
    base.tapItemRelay.asObservable()
  }
}
