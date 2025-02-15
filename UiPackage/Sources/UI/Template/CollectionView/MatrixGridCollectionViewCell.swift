import UIKit
import SnapKit

class MatrixGridCell: UICollectionViewCell {
  private let label = UILabel().apply {
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textColor = .white
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    contentView.addSubview(label)
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func configure(with number: Int, color: UIColor) {
    backgroundColor = color
    label.text = "\(number)"
  }
}
