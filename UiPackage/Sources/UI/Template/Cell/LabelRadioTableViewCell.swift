import UIKit
import SnapKit
import RxSwift
import RxCocoa

public struct LabelRadioItem: Identifiable, Equatable, Sendable {
  public let id: String
  public var text: String
  public var isSelected: Bool
  
  public init(
    id: String = UUID().uuidString,
    text: String,
    isSelected: Bool
  ) {
    self.id = id
    self.text = text
    self.isSelected = isSelected
  }
}

public class LabelRadioTableViewCell: UITableViewCell {
  var disposeBag = DisposeBag()
  var itemId: String?
  // MARK: - UI
  let labelRadio = LabelRadio()
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraint()
    selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    itemId = nil
  }
  
  private func setupView() {
    contentView.addSubview(labelRadio)
  }
  
  private func setupConstraint() {
    labelRadio.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: Spacing.md, left: Spacing.lg, bottom: Spacing.md, right: Spacing.lg))
    }
  }
  
  // MARK: - Configuration
  @MainActor
  public func configure(with item: LabelRadioItem) {
    itemId = item.id
    labelRadio.text = item.text
    labelRadio.isSelected = item.isSelected
  }
  
  public func focusTextView() {
    labelRadio.textView.becomeFirstResponder()
  }
}

public extension Reactive where Base: LabelRadioTableViewCell {
  @MainActor
  var textEditCompleted: ControlEvent<Void> {
    base.labelRadio.rx.editingCompleted
  }
  
  @MainActor
  var selectionChanged: ControlEvent<Bool> {
    .init(events: base.labelRadio.rx.isSelected.asObservable())
  }
}
