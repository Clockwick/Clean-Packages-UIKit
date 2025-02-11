import UIKit
import RxSwift
import RxCocoa

public class BaseModalViewController: UIViewController {
  // MARK: - Main View
  public let mainView = BaseModalView()
  
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  
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
  }
  
  // MARK: - Animations
  public func animateIn() {
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
  
  public func animateOut(completion: @escaping () -> Void) {
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
  
  deinit {
    print(
      "###",
      "DEBUG:",
      "DEINIT MODAL: \(self.description)"
    )
  }
}
