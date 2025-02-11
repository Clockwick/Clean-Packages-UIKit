import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils

public class Radio: UIView {
  // MARK: - Private Properties
  private let disposeBag = DisposeBag()
  fileprivate let isSelectedRelay = BehaviorRelay<Bool>(value: false)
  
  // MARK: - UI Components
  private let radioImage = UIImageView()
  private let button = UIButton()
  
  // MARK: - Public Properties
  public var isSelected: Bool {
    get { isSelectedRelay.value }
    set {
      isSelectedRelay.accept(newValue)
      updateUI(isSelected: newValue)
    }
  }
  
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
    let config = UIImage.SymbolConfiguration(pointSize: 24)
    radioImage.preferredSymbolConfiguration = config
    radioImage.image = UIImage(systemName: "circle")
    radioImage.tintColor = .systemGray3
    
    addSubviews(radioImage, button)
  }
  
  private func setupConstraint() {
    radioImage.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(24)
    }
    
    button.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupAction() {
    button.rx.tap
      .map { [unowned self] in !self.isSelected }
      .bind(to: isSelectedRelay)
      .disposed(by: disposeBag)
    
    isSelectedRelay
      .subscribe(onNext: { [weak self] isSelected in
        self?.updateUI(isSelected: isSelected)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateUI(isSelected: Bool) {
    let imageName = isSelected ? "checkmark.circle.fill" : "circle"
    radioImage.image = UIImage(systemName: imageName)
    radioImage.tintColor = isSelected ? .systemBlue : .systemGray3
  }
}

public extension Reactive where Base: Radio {
  @MainActor
  var isSelected: ControlProperty<Bool> {
    .init(values: base.isSelectedRelay.asObservable(),
          valueSink: Binder(base) { radio, isSelected in
      radio.isSelected = isSelected
    })
  }
}
