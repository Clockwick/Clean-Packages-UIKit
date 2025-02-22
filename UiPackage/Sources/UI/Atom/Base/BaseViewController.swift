//
//  BaseViewController.swift
//  Pods
//
//  Created by Paratthakorn Sribunyong on 16/11/2567 BE.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

@MainActor
open class BaseViewController<VM: ViewModelType>: UIViewController {
  public var baseNavigationController: BaseNavigationController? {
    navigationController as? BaseNavigationController
  }
  
  public var viewModel: VM
  
  public let disposeBag = DisposeBag()
  
  public init(viewModel: VM) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    hideKeyboardWhenTappedAround()
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
  }

  deinit {
    print(
      "###",
      "DEBUG:",
      "DEINIT \(self.description)"
    )
  }
}

// MARK: - Modal Presentation
public extension BaseViewController {
  func showModal(
    title: String,
    description: String,
    primaryTitle: String = "Confirm",
    secondaryTitle: String = "Cancel",
    primaryAction: @escaping () -> Void,
    secondaryAction: @escaping () -> Void
  ) {
    let modalVC = BaseModalViewController()
    modalVC.mainView.rx.state.onNext(
      .init(
        title: title,
        description: description,
        primaryTitle: primaryTitle,
        secondaryTitle: secondaryTitle
      )
    )
    
    modalVC.mainView.rx.actions.subscribe(onNext: { [weak modalVC]  action in
      switch action {
      case .didTapPrimaryButton:
        modalVC?.animateOut {
          modalVC?.dismiss(animated: false) {
            primaryAction()
          }
        }
      case .didTapSecondaryButton:
        modalVC?.animateOut {
          modalVC?.dismiss(animated: false) {
            secondaryAction()
          }
        }
      }
    })
    .disposed(by: disposeBag)
    
    present(modalVC, animated: false) { [weak modalVC] in
      modalVC?.animateIn()
    }
  }
}
