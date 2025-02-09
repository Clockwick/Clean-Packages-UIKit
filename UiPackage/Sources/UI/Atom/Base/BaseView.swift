//
//  BaseView.swift
//  UI
//
//  Created by Paratthakorn Sribunyong on 9/2/2568 BE.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils

public class BaseView: UIView {
  // MARK: - Reactive properties
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  
  // MARK: - Property observers
  
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
    
  }
  
  private func setupConstraint() {
    
  }
  
  private func setupAction() {
    
  }
}

public extension Reactive where Base: BaseView {
  
}
