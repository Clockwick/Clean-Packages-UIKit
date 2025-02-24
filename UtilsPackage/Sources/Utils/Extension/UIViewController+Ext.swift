//
//  UIViewController+Ext.swift
//  Utils
//
//  Created by Paratthakorn Sribunyong on 13/2/2568 BE.
//
import UIKit

public extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
