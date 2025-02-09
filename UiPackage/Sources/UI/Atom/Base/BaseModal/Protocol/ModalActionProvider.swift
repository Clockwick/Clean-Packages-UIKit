import UIKit
import RxSwift
import RxCocoa

public protocol ModalActionProvider {
  var primaryAction: PublishRelay<Void> { get }
  var secondaryAction: PublishRelay<Void> { get }
  func setupActions(in modalController: BaseModalViewController)
}
