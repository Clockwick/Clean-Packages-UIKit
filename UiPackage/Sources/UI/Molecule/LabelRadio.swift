import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils

public class LabelRadio: UIView {
  // MARK: - Private Properties
  private let disposeBag = DisposeBag()
  fileprivate let textRelay = BehaviorRelay<String>(value: "")
  fileprivate let editingCompletedRelay = PublishRelay<Void>()
  
  // MARK: - UI
  public let textView = UITextView().apply {
    $0.font = .systemFont(ofSize: 17)
    $0.textContainer.lineFragmentPadding = 0
    $0.textContainerInset = .zero
    $0.isScrollEnabled = false
    $0.isEditable = true
    $0.backgroundColor = .clear
    $0.clipsToBounds = true
    $0.sizeToFit()
    $0.textAlignment = .left
  }
  
  fileprivate let radio = Radio()
  
  // MARK: - Public Properties
  public var text: String {
    get { textRelay.value }
    set { textRelay.accept(newValue) }
  }
  
  public var isSelected: Bool {
    get { radio.isSelected }
    set { radio.isSelected = newValue }
  }
  
  // MARK: - Init
  public init() {
    super.init(frame: .zero)
    setupView()
    setupConstraint()
    setupAction()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubviews(radio, textView)
  }
  
  private func setupConstraint() {
    radio.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.equalToSuperview().offset(Spacing.xs)
      $0.size.equalTo(24)
    }
    
    textView.snp.makeConstraints {
      $0.left.equalTo(radio.snp.right).offset(Spacing.sm)
      $0.top.equalToSuperview().offset(Spacing.xs)
      $0.bottom.right.equalToSuperview()
      $0.height.greaterThanOrEqualTo(24)
    }
  }
  
  private func setupAction() {
    textView.delegate = self
    
    textRelay
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if text != self.textView.text {
          self.textView.text = text
        }
      })
      .disposed(by: disposeBag)
    
    textView.rx.text.orEmpty
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        guard self.textRelay.value != text else { return }
        self.textRelay.accept(text)
      })
      .disposed(by: disposeBag)
    
    textView.rx.didEndEditing
      .debug()
      .subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      self.editingCompletedRelay.accept(())
    })
    .disposed(by: disposeBag)
  }
}

extension LabelRadio: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    invalidateIntrinsicContentSize()
  }
}

// MARK: - UIGestureRecognizerDelegate
extension LabelRadio: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    // Only handle taps outside the textView
    if let view = touch.view, (view == textView || view.isDescendant(of: textView)) {
      return false
    }
    return true
  }
}

public extension Reactive where Base: LabelRadio {
  @MainActor
  var text: ControlProperty<String> {
    .init(values: base.textRelay.asObservable(),
          valueSink: Binder(base) { labelRadio, text in
      labelRadio.text = text
    })
  }
  
  @MainActor
  var editingCompleted: ControlEvent<Void> {
    .init(events: base.editingCompletedRelay.asObservable())
  }
  
  @MainActor
  var isSelected: ControlProperty<Bool> {
    base.radio.rx.isSelected
  }
}
