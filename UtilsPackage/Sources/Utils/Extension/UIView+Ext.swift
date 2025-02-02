//
//  UIView+Ext.swift
//  Utils
//
//  Created by Paratthakorn Sribunyong on 2/2/2568 BE.
//

import UIKit
import SnapKit

protocol NSLayoutConstraintAttributeConvertable {
  var attribute: NSLayoutConstraint.Attribute { get }
}

public extension UIView {
  enum Layout {
    public enum Dimension: NSLayoutConstraintAttributeConvertable {
      case width
      case height
      
      var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .width:
          return .width
        case .height:
          return .height
        }
      }
    }
  }
  
  // MARK: - Auto Layout
  func anchor(to viewController: UIViewController) {
    snp.makeConstraints {
      $0.top.equalTo(viewController.view.safeAreaLayoutGuide.snp.top)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Variadic Function
  // Improve code readability and flexibility by using variadic function instead of a traditional array
  // Consider opting for the variadic approach for a more streamlined and expressive coding experience
  
  /**
   - Adds multiple UIViews using a variadic function for enhanced readability and flexibility
   - Consider this approach for more concise and expressive code
   */
  func addSubviews(_ views: UIView...) {
    views.forEach {
      addSubview($0)
    }
  }
  
  func removeSubviews() {
    subviews.forEach {
      $0.removeFromSuperview()
    }
  }
  
  @available(iOS 16.0, *)
  func setAnchorPoint(_ point: CGPoint) {
    if let superframe = superview?.frame {
      let oldOrigin = frame.origin
      anchorPoint = point
      if point.x == 0, frame.origin.x == oldOrigin.x {
        // somehow there's no change to the frame of x after origin change
        // use superview width to determined the offset
        // Divide by 2 because value of 0.5 is actually at `center` then it means value to translate
        // to left / right side is only that of halved
        let offsetX = (superframe.width - superframe.width * point.x) / 2
        let newOrigin = CGPoint(x: superframe.width * point.x, y: superframe.height * point.y)
        let translation = CGPoint(x: offsetX, y: newOrigin.y - oldOrigin.y)
        frame.origin = CGPoint(x: center.x - translation.x, y: center.y - translation.y)
      }
    } else {
      let oldOrigin = frame.origin
      layer.anchorPoint = point
      let newOrigin = frame.origin
      let translation = CGPoint(x: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y)
      center = CGPoint(x: center.x - translation.x, y: center.y - translation.y)
    }
  }
  
  @available(*, deprecated, message: "Move to use  func addBorder(toSide:withColor:withThickness)")
  func addTopBorder(color: UIColor, width: CGFloat) {
    addBorder(frame: CGRect(x: 0, y: 0, width: bounds.width, height: width), color: color)
  }
  
  @available(*, deprecated, message: "Move to use  func addBorder(toSide:withColor:withThickness)")
  func addRightBorder(color: UIColor, width: CGFloat) {
    addBorder(frame: CGRect(x: bounds.width - width, y: 0, width: width, height: bounds.height), color: color)
  }
  
  @available(*, deprecated, message: "Move to use  func addBorder(toSide:withColor:withThickness)")
  func addBottomBorder(color: UIColor, width: CGFloat) {
    addBorder(frame: CGRect(x: 0, y: bounds.height - width, width: bounds.width, height: width), color: color)
  }
  
  @available(*, deprecated, message: "Move to use  func addBorder(toSide:withColor:withThickness)")
  func addLeftBorder(color: UIColor, width: CGFloat) {
    addBorder(frame: CGRect(x: 0, y: 0, width: width, height: bounds.height), color: color)
  }
  
  func setBackgroundImage(_ image: UIImage) {
    subviews.first(where: { $0 is UIImageView })?.removeFromSuperview()
    UIImageView(image: image).apply {
      $0.frame = bounds
      $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      $0.contentMode = .scaleAspectFill
      insertSubview($0, at: 0)
    }
  }
  
  private func addBorder(frame: CGRect, color: UIColor) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = frame
    layer.addSublayer(border)
  }
  
  // MARK: Screenshot
  var screenshot: UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
    drawHierarchy(in: bounds, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image ?? UIImage()
  }
  
  enum ViewSide {
    case left
    case right
    case top
    case bottom
  }
  
  func addBorder(
    toSide side: ViewSide,
    withColor color: UIColor,
    withThickness thickness: CGFloat
  ) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    switch side {
    case .left:
      border.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: frame.height)
    case .right:
      border.frame = CGRect(x: frame.width - thickness, y: 0.0, width: thickness, height: frame.height)
    case .top:
      border.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: thickness)
    case .bottom:
      border.frame = CGRect(x: 0.0, y: frame.height - thickness, width: frame.width, height: thickness)
    }
    
    layer.addSublayer(border)
  }
}
