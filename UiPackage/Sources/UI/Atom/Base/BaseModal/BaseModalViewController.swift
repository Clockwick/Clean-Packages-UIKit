import UIKit
import RxSwift
import RxCocoa

public class BaseModalViewController: UIViewController {
  // MARK: - Properties
  private let mainView = BaseModalView()
  private let disposeBag = DisposeBag()
  
  // MARK: - Reactive Properties
  let primaryAction = PublishRelay<Void>()
  let secondaryAction = PublishRelay<Void>()
  
  // MARK: - Init
  public init() {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overFullScreen
    modalTransitionStyle = .crossDissolve
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  public override func loadView() {
    view = mainView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupBindings()
  }
  
  // MARK: - Setup
  private func setupBindings() {
    mainView.primaryButton.rx.tap
      .bind(to: primaryAction)
      .disposed(by: disposeBag)
    
    mainView.secondaryButton.rx.tap
      .bind(to: secondaryAction)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Public Methods
  func configure(title: String, description: String, primaryTitle: String, secondaryTitle: String) {
    mainView.configure(
      title: title,
      description: description,
      primaryTitle: primaryTitle,
      secondaryTitle: secondaryTitle
    )
  }
  
  // MARK: - Animations
  func animateIn() {
    // Initial state
    view.alpha = 0
    mainView.containerView.transform = CGAffineTransform(translationX: 0, y: mainView.containerView.frame.height)
    
    // Spring animation for container
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.5,
      options: .curveEaseOut
    ) {
      self.mainView.containerView.transform = .identity
    }
    
    // Fade animation for background
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      options: .curveEaseInOut
    ) {
      self.view.alpha = 1
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
  }
  
  func animateOut(completion: @escaping () -> Void) {
    // Spring animation for container
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.5,
      options: .curveEaseIn
    ) {
      self.mainView.containerView.transform = CGAffineTransform(translationX: 0, y: self.mainView.containerView.frame.height)
    }
    
    // Fade animation for background
    UIView.animate(
      withDuration: 0.3,
      delay: 0.1, // Slight delay to sync with container movement
      options: .curveEaseInOut
    ) {
      self.view.alpha = 0
      self.view.backgroundColor = .clear
    } completion: { _ in
      completion()
    }
  }
}

extension BaseViewController {
  // MARK: - Modal Presentation
  public func showModal(
    title: String,
    description: String,
    primaryTitle: String = "Confirm",
    secondaryTitle: String = "Cancel",
    primaryAction: @escaping () -> Void,
    secondaryAction: @escaping () -> Void
  ) {
    let modalVC = BaseModalViewController()
    modalVC.configure(
      title: title,
      description: description,
      primaryTitle: primaryTitle,
      secondaryTitle: secondaryTitle
    )
    
    modalVC.primaryAction
      .subscribe(onNext: { [weak modalVC] in
        modalVC?.animateOut {
          modalVC?.dismiss(animated: false) {
            primaryAction()
          }
        }
      })
      .disposed(by: disposeBag)
    
    modalVC.secondaryAction
      .subscribe(onNext: { [weak modalVC] in
        modalVC?.animateOut {
          modalVC?.dismiss(animated: false) {
            secondaryAction()
          }
        }
      })
      .disposed(by: disposeBag)
    
    present(modalVC, animated: false) { [weak modalVC] in
      modalVC?.animateIn()
    }
  }
}
