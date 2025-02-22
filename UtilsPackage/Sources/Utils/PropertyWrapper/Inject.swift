//
//  File.swift
//  Utils
//
//  Created by Paratthakorn Sribunyong on 21/2/2568 BE.
//

@propertyWrapper
public struct Inject<T> {
  public let wrappedValue: T
  
  public init() {
    self.wrappedValue = DependencyContainer.shared.resolve()
  }
}
