import Foundation

public extension Array {
  subscript(safe index: Int) -> Element? {
    get {
      return indices.contains(index) ? self[index] : nil
    }
    
    set(newValue) {
      if indices.contains(index) {
        replaceSubrange(index...index, with: [newValue].compactMap { $0 })
      }
    }
  }
}
