//
//  ScopeFunction+Intellisense.swift
//  Utility
//
//  Created by Paratthakorn Sribunyong on 14/11/2567 BE.
//

import UIKit

// MARK: - Enhance intellisense for apply function
public extension UILabel {
    @discardableResult
    func apply(_ block: (UILabel) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UIButton {
    @discardableResult
    func apply(_ block: (UIButton) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UIStackView {
    @discardableResult
    func apply(_ block: (UIStackView) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UIImageView {
    @discardableResult
    func apply(_ block: (UIImageView) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UITextField {
    @discardableResult
    func apply(_ block: (UITextField) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

/// UIScrollView also cover intellisense for UITableView and UICollectionView
public extension UIScrollView {
    @discardableResult
    func apply(_ block: (UIScrollView) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UITableViewCell {
    @discardableResult
    func apply(_ block: (UITableViewCell) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UICollectionViewCell {
    @discardableResult
    func apply(_ block: (UICollectionViewCell) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UIPickerView {
    @discardableResult
    func apply(_ block: (UIPickerView) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UIDatePicker {
    @discardableResult
    func apply(_ block: (UIDatePicker) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UISegmentedControl {
    @discardableResult
    func apply(_ block: (UISegmentedControl) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UISlider {
    @discardableResult
    func apply(_ block: (UISlider) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UIProgressView {
    @discardableResult
    func apply(_ block: (UIProgressView) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UIActivityIndicatorView {
    @discardableResult
    func apply(_ block: (UIActivityIndicatorView) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UIPageControl {
    @discardableResult
    func apply(_ block: (UIPageControl) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension UITabBar {
    @discardableResult
    func apply(_ block: (UITabBar) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

public extension URLComponents {
    func apply(_ block: (inout URLComponents) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

public extension UIButton.Configuration {
    @discardableResult
    func apply(_ block: (inout UIButton.Configuration) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

