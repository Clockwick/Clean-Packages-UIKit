import UIKit
import SnapKit
import RxSwift
import RxCocoa

public struct TextViewRadioItem: Identifiable, Equatable, Sendable {
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

public class TextViewRadioTableViewCell: UITableViewCell {
  var disposeBag = DisposeBag()
  var itemId: String?
  // MARK: - UI
  let textViewRadio = TextViewRadio()
  
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
    contentView.addSubview(textViewRadio)
  }
  
  private func setupConstraint() {
    textViewRadio.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: Spacing.md, left: Spacing.lg, bottom: Spacing.md, right: Spacing.lg))
    }
  }
  
  // MARK: - Configuration
  @MainActor
  public func configure(with item: TextViewRadioItem) {
    itemId = item.id
    textViewRadio.text = item.text
    textViewRadio.isSelected = item.isSelected
  }
  
  public func focusTextView() {
    textViewRadio.textView.becomeFirstResponder()
  }
}

public extension Reactive where Base: TextViewRadioTableViewCell {
  @MainActor
  var textEditCompleted: ControlEvent<Void> {
    base.textViewRadio.rx.editingCompleted
  }
  
  @MainActor
  var selectionChanged: ControlEvent<Bool> {
    .init(events: base.textViewRadio.rx.isSelected.asObservable())
  }
}
