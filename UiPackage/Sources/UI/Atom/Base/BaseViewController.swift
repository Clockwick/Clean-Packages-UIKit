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

open class BaseViewController<VM: ViewModelType>: UIViewController {
  public var baseNavigationController: BaseNavigationController? {
    navigationController as? BaseNavigationController
  }
  
  public var viewModel: VM
  
  
  // MARK: - Modal Properties
  private var modalViewController: UIViewController?
  private let modalView = BaseModalView()
  private let modalPrimaryAction = PublishRelay<Void>()
  private let modalSecondaryAction = PublishRelay<Void>()
  
  public let disposeBag = DisposeBag()
  
  public init(viewModel: VM) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public let loadingView = UIView().apply {
    $0.isHidden = true
    $0.backgroundColor = .systemBackground
    $0.layer.zPosition = 1
  }
  
  public let activityIndicatorView = UIActivityIndicatorView().apply {
    $0.color = .label
    $0.layer.zPosition = 1
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAction()
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    view.addSubview(loadingView)
    view.bringSubviewToFront(loadingView)
    loadingView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    loadingView.addSubview(activityIndicatorView)
    activityIndicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(40)
    }
  }
  
  private func setupAction() {
    setupModalActions()
  }
  
  // MARK: - Modal Methods
  private func setupModalActions() {
    modalView.primaryButton.rx.tap
      .bind(to: modalPrimaryAction)
      .disposed(by: disposeBag)
    
    modalView.secondaryButton.rx.tap
      .bind(to: modalSecondaryAction)
      .disposed(by: disposeBag)
  }
  
  deinit {
    print(
      "###",
      "DEBUG:",
      "DEINIT \(self.description)"
    )
  }
}
