import UIKit
import SnapKit

public class MatrixGridCollectionViewCell: UICollectionViewCell {
  // MARK: - UI Components
  private let titleLabel = UILabel().apply {
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = .label
  }
  
  private let contentStackView = UIStackView().apply {
    $0.axis = .vertical
    $0.spacing = Spacing.lg
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  private var labelRadios: [LabelRadio] = []
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    labelRadios.forEach { $0.removeFromSuperview() }
    labelRadios.removeAll()
  }
  
  private func setupView() {
    contentView.addSubviews(titleLabel, contentStackView)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Spacing.md)
      $0.left.right.equalToSuperview().inset(Spacing.md)
      $0.height.equalTo(44)
    }
    
    contentStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Spacing.md)
      $0.left.right.equalToSuperview().inset(Spacing.md)
      $0.bottom.lessThanOrEqualToSuperview().inset(Spacing.md)
    }
  }
  
  public func configure(with model: UIModel) {
    titleLabel.text = model.title
    
    labelRadios.forEach { $0.removeFromSuperview() }
    labelRadios.removeAll()
    
    model.items.forEach { item in
      let labelRadio = LabelRadio()
      labelRadio.configure(text: item.text, isSelected: item.isDone)
      labelRadio.snp.makeConstraints {
        $0.height.equalTo(32) // Adjust this value based on your needs
      }
      contentStackView.addArrangedSubview(labelRadio)
      labelRadios.append(labelRadio)
    }
  }
}

// MARK: - Types
extension MatrixGridCollectionViewCell {
  public struct UIModel: Equatable {
    public let title: String
    public let items: [ItemUIModel]
    
    public init(title: String, items: [ItemUIModel]) {
      self.title = title
      self.items = items
    }
    
    public struct ItemUIModel: Equatable {
      public let text: String
      public let isDone: Bool
      
      public init(text: String, isDone: Bool) {
        self.text = text
        self.isDone = isDone
      }
    }
  }
}
