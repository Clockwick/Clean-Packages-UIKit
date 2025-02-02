// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit

@MainActor
public final class DevTool: @unchecked Sendable {
  // Singleton instance
  public static let shared = DevTool()
  private init() {}
  
  // Properties
  private weak var window: UIWindow?
  
  // MARK: - Configuration
  @MainActor
  public func configure(with window: UIWindow?) {
    self.window = window
  }
  
  // MARK: - Show/Hide DevTool
  @MainActor
  public func showDevTool() {
    guard let window = window,
          window.rootViewController?.presentedViewController == nil else {
      return
    }
    
    let devToolVC = DevToolViewController()
    devToolVC.modalPresentationStyle = .fullScreen
    window.rootViewController?.present(devToolVC, animated: true)
  }
}
