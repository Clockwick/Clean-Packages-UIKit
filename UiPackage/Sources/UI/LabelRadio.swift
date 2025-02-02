//
//  LabelRadio.swift
//  UI
//
//  Created by Paratthakorn Sribunyong on 2/2/2568 BE.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils

public class LabelRadio: UIView {
  // MARK: - Reactive properties
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let label = UILabel().apply {
    $0.isHidden = false
    $0.textAlignment = .left
    $0.isUserInteractionEnabled = true
  }
  
  private let textField = UITextField().apply {
    $0.isHidden = true
    $0.isEnabled = true
    $0.returnKeyType = .done
  }
  
  private let radio = Radio()
  
  // MARK: - Property observers
  public var text: String = "" {
    didSet {
      label.text = text
    }
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
    addSubviews(
      radio,
      label,
      textField
    )
  }
  
  private func setupConstraint() {
    radio.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.bottom.equalToSuperview()
      $0.width.height.equalTo(24)
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
    // Add tap gesture to label
    let tapGesture = UITapGestureRecognizer()
    label.addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event
      .subscribe(onNext: { [weak self] _ in
        self?.switchToTextField()
      })
      .disposed(by: disposeBag)
    
    // Handle text field events
    textField.rx.controlEvent(.editingDidEndOnExit)
      .subscribe(onNext: { [weak self] in
        self?.switchToLabel()
      })
      .disposed(by: disposeBag)
    
    textField.rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: { [weak self] in
        self?.switchToLabel()
      })
      .disposed(by: disposeBag)
  }
  
  private func switchToTextField() {
    label.isHidden = true
    textField.isHidden = false
    textField.becomeFirstResponder()
  }
  
  private func switchToLabel() {
    text = textField.text ?? ""
    textField.isHidden = true
    label.isHidden = false
    textField.resignFirstResponder()
  }
}

public extension Reactive where Base: LabelRadio {
  
}

