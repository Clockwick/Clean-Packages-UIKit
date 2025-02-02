//
//  ScopeFunction.swift
//  Utility
//
//  Created by Paratthakorn Sribunyong on 14/11/2567 BE.
//

import Foundation
import UIKit

public protocol ScopeFunction {}

public extension ScopeFunction {
    @discardableResult
    func apply(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
    
    @discardableResult
    func also(_ block: () -> Void) -> Self {
        block()
        return self
    }
    
    @discardableResult
    func `let`<T>(_ block: (Self) -> T) -> T {
        block(self)
    }
}

extension NSObject: ScopeFunction {}
extension Array: ScopeFunction {}
extension Dictionary: ScopeFunction {}
extension Set: ScopeFunction {}
extension UIView: ScopeFunction {}
extension UIControl: ScopeFunction {}

@discardableResult
public func run<T>(_ block: () -> T) -> T {
    block()
}

@discardableResult
public func with<T, R>(_ receiver: T, _ block: (T) -> R) -> R {
    block(receiver)
}

@discardableResult
public func with<T, R>(_ receiver: inout T, _ block: (inout T) -> R) -> R {
    block(&receiver)
}
