import UIKit

public protocol ModalContentView: UIView {
  var containerInsets: UIEdgeInsets { get }
  func setupInContainer(_ container: UIView)
}

// Default implementation
extension ModalContentView {
  public var containerInsets: UIEdgeInsets {
    .init(top: Spacing.xl2, left: Spacing.xl2, bottom: Spacing.xl2, right: Spacing.xl2)
  }
}
