// MARK: - BaseModalView.swift
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseModalView: UIView {
  // MARK: - UI Components
  public let containerView = UIView()
  
  private let titleLabel = UILabel().apply {
    $0.font = .systemFont(ofSize: 18, weight: .bold)
    $0.textColor = .label
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  private let descriptionLabel = UILabel().apply {
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .secondaryLabel
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  private let buttonStackView = UIStackView().apply {
    $0.axis = .vertical
    $0.spacing = 8
    $0.distribution = .fillEqually
  }
  
  let primaryButton = UIButton(type: .system).apply {
    $0.backgroundColor = .systemBlue
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    $0.layer.cornerRadius = 8
  }
  
  let secondaryButton = UIButton(type: .system).apply {
    $0.backgroundColor = .systemGray6
    $0.setTitleColor(.label, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
    $0.layer.cornerRadius = 8
  }
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupView() {
    backgroundColor = .clear
    
    addSubview(containerView)
    containerView.backgroundColor = .systemBackground
    containerView.layer.cornerRadius = 16
    containerView.clipsToBounds = true
    
    // Add shadow to container view
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOffset = CGSize(width: 0, height: -2)
    containerView.layer.shadowOpacity = 0.1
    containerView.layer.shadowRadius = 6
    
    // Create a wrapper view for content to maintain corner radius with shadow
    let contentView = UIView()
    contentView.backgroundColor = .systemBackground
    containerView.addSubview(contentView)
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(buttonStackView)
    
    buttonStackView.addArrangedSubview(primaryButton)
    buttonStackView.addArrangedSubview(secondaryButton)
    
    // Add tap gesture to background for dismissal
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
    self.addGestureRecognizer(tapGesture)
  }
  
  private func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-24)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.trailing.equalToSuperview().inset(24)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.leading.trailing.equalToSuperview().inset(24)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.bottom.equalToSuperview().offset(-24)
    }
    
    [primaryButton, secondaryButton].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(50)
      }
    }
  }
  
  // MARK: - Actions
  @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: self)
    if !containerView.frame.contains(location) {
      secondaryButton.sendActions(for: .touchUpInside)
    }
  }
  
  // MARK: - Public Methods
  func configure(title: String, description: String, primaryTitle: String, secondaryTitle: String) {
    titleLabel.text = title
    descriptionLabel.text = description
    primaryButton.setTitle(primaryTitle, for: .normal)
    secondaryButton.setTitle(secondaryTitle, for: .normal)
  }
}
