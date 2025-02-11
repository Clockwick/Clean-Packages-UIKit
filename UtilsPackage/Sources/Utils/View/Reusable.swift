import UIKit

public protocol Reusable {
  static var reuseID: String { get }
}

public extension Reusable {
  static var reuseID: String {
    String(describing: self)
  }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
extension UIViewController: Reusable {}

public extension UITableView {
  func register<T: UITableViewCell>(cellType: T.Type = T.self) {
    register(cellType, forCellReuseIdentifier: cellType.reuseID)
  }
  
  func dequeueReusableCell<T>(
    ofType cellType: T.Type = T.self,
    for indexPath: IndexPath
  ) -> T where T: UITableViewCell {
    guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? T else {
      fatalError("""
             Failed to dequeue a cell with identifier \(cellType.reuseID) matching type \(cellType.self). 
             Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand
            """)
    }
    return cell
  }
}

public extension UIStoryboard {
  func instantiateViewController<T>(ofType type: T.Type) -> T where T: UIViewController {
    guard let viewController = instantiateViewController(withIdentifier: type.reuseID) as? T else {
      fatalError()
    }
    return viewController
  }
}
