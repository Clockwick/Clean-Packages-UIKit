import UIKit
import SnapKit
import Utils

class LabelRadio: UIView {
  // MARK: - UI Components
  private let radio = Radio()
  private let label = UILabel().apply {
    $0.textAlignment = .left
    $0.font = .systemFont(ofSize: 17)
    $0.textColor = .label
    $0.numberOfLines = 0
  }
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupView() {
    addSubviews(radio, label)
  }
  
  private func setupConstraints() {
    radio.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24)
    }
    
    label.snp.makeConstraints {
      $0.left.equalTo(radio.snp.right).offset(Spacing.sm)
      $0.right.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  // MARK: - Configuration
  func configure(text: String, isSelected: Bool) {
    label.text = text
    radio.isSelected = isSelected
  }
}
