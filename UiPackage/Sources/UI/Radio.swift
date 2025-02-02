//
//  Radio.swift
//  UI
//
//  Created by Paratthakorn Sribunyong on 2/2/2568 BE.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils

public class Radio: UIView {
  private let disposeBag = DisposeBag()
  
  // MARK: - UI Componentss
  private let radioImage = UIImageView()
  fileprivate let button = UIButton()
  
  public var isSelected: Bool = false {
    didSet {
      let imageName = isSelected ? "checkmark.circle.fill" : "circle"
      radioImage.image = UIImage(systemName: imageName)
      radioImage.tintColor = isSelected ? .systemBlue : .systemGray3
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
      $0.width.height.equalTo(24)
    }
    
    button.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupAction() {
    button.rx.tap
      .subscribe(
        onNext: { [weak self] _ in
          self?.isSelected.toggle()
        }
      )
      .disposed(by: disposeBag)
  }
}

public extension Reactive where Base: Radio {
  var tap: ControlEvent<Void> {
    base.button.rx.tap
  }
}
