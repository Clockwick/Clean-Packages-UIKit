public class DependencyContainer {
  public static let shared = DependencyContainer()
  private var dependencies: [String: Any] = [:]
  
  public func register<T>(_ dependency: T) {
    let key = String(describing: T.self)
    dependencies[key] = dependency
  }
  
  // For protocol types, we need to specify the protocol explicitly
  public func register<T>(_ dependency: Any, as type: T.Type) {
    let key = String(describing: T.self)
    dependencies[key] = dependency
  }
  
  public func resolve<T>() -> T {
    let key = String(describing: T.self)
    guard let dependency = dependencies[key] as? T else {
      fatalError("No dependency found for \(key)")
    }
    return dependency
  }
}
