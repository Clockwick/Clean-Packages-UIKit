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
  private var quadrants: [MatrixGridCollectionViewCell.UIModel] = []
  
  // MARK: - Initialization
  public init() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = .zero
    
    super.init(frame: .zero, collectionViewLayout: layout)
    
    backgroundColor = .systemBackground
    delegate = self
    dataSource = self
    isScrollEnabled = false
    register(MatrixGridCollectionViewCell.self, forCellWithReuseIdentifier: MatrixGridCollectionViewCell.reuseID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(with quadrants: [MatrixGridCollectionViewCell.UIModel]) {
    self.quadrants = quadrants
    reloadData()
  }
}

// MARK: - UICollectionViewDataSource
extension MatrixGridCollectionView: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return quadrants.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatrixGridCollectionViewCell.reuseID, for: indexPath) as! MatrixGridCollectionViewCell
    cell.configure(with: quadrants[indexPath.item])
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
