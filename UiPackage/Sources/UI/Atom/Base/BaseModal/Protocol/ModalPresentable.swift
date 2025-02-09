import UIKit

public protocol ModalPresentable {
  @MainActor func showModal(_ modalController: BaseModalViewController)
  @MainActor func dismissModal(_ modalController: BaseModalViewController)
}

// Default implementation for UIViewController
extension ModalPresentable where Self: UIViewController {
  @MainActor
  public func showModal(_ modalController: BaseModalViewController) {
    present(modalController, animated: false) { [weak modalController] in
      modalController?.animateIn()
    }
  }
  
  @MainActor
  public func dismissModal(_ modalController: BaseModalViewController) {
    modalController.animateOut { [weak modalController] in
      modalController?.dismiss(animated: false)
    }
  }
}
