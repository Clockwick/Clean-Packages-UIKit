//
//  DevToolViewController.swift
//  DevTool
//
//  Created by Paratthakorn Sribunyong on 2/2/2568 BE.
//

import UIKit
import SnapKit

class DevToolViewController: UIViewController {
  
  // MARK: - Properties
  private let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Close", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    view.backgroundColor = .white
    
    view.addSubview(closeButton)
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
    
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - Actions
  @objc private func closeButtonTapped() {
    dismiss(animated: true)
  }
}
