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
  private var editingSubscription: Disposable?
  
  // MARK: - UI
  private let label = UILabel().apply {
    $0.textAlignment = .left
    $0.isUserInteractionEnabled = true
  }
  
  private let textField = UITextField().apply {
    $0.isHidden = true
    $0.returnKeyType = .done
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
    addSubviews(radio, label, textField)
  }
  
  private func setupConstraint() {
    radio.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24)
    }
    
    label.snp.makeConstraints {
      $0.left.equalTo(radio.snp.right).offset(Spacing.sm)
      $0.top.bottom.right.equalToSuperview()
    }
    
    textField.snp.makeConstraints {
      $0.left.equalTo(radio.snp.right).offset(Spacing.sm)
      $0.top.bottom.right.equalToSuperview()
    }
  }
  
  private func setupAction() {
    let tapGesture = UITapGestureRecognizer()
    label.addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event
      .subscribe(onNext: { [weak self] _ in
        self?.switchToTextField()
      })
      .disposed(by: disposeBag)
    
    textRelay
      .subscribe(onNext: { [weak self] text in
        self?.label.text = text
      })
      .disposed(by: disposeBag)
  }
  
  private func switchToTextField() {
    label.isHidden = true
    textField.isHidden = false
    textField.text = text
    textField.becomeFirstResponder()
    
    // Clean up any existing subscription
    editingSubscription?.dispose()
    
    // Create new subscription for this editing session
    editingSubscription = textField.rx.controlEvent(.editingDidEndOnExit)
      .take(1)
      .subscribe(onNext: { [weak self] in
        self?.handleEditingEnd()
      })
  }
  
  private func handleEditingEnd() {
    editingSubscription?.dispose()
    editingSubscription = nil
    switchToLabel()
  }
  
  private func switchToLabel() {
    let newText = textField.text ?? ""
    textField.isHidden = true
    label.isHidden = false
    textField.resignFirstResponder()
    
    // Only update text and trigger completion if text actually changed
    if newText != text {
      textRelay.accept(newText)
      editingCompletedRelay.accept(())
    }
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
