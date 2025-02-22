import UIKit
import RxSwift
import RxCocoa
import Utils

public class DateButton: UIButton {
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  private let dateFormatter = DateFormatter().apply {
    $0.dateFormat = "d MMM yyyy"
  }
  
  // MARK: - Initialization
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupView() {
    titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    setTitleColor(.label, for: .normal)
    setTitleColor(.secondaryLabel, for: .highlighted)
  }
  
  public func configure(with date: Date) {
    setTitle(dateFormatter.string(from: date), for: .normal)
  }
}

// MARK: - Reactive Extension
public extension Reactive where Base: DateButton {
  var tap: ControlEvent<Void> {
    return controlEvent(.touchUpInside)
  }
}
