import UIKit

public extension UIStackView {
    convenience init(
        arrangedSubviews: [UIView] = [],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
    
    func insertArrangedSubviews(_ views: [UIView], at index: Int) {
        views.enumerated().forEach {
            insertArrangedSubview($0.element, at: index + $0.offset)
        }
    }
    
    func insertArrangedSubviews(_ views: [UIView], after view: UIView) {
        guard let index = arrangedSubviews.firstIndex(of: view) else { return }
        let indexToInsert = index + 1
        views.enumerated().forEach {
            insertArrangedSubview($0.element, at: indexToInsert + $0.offset)
        }
    }
    
    func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func hiddenSubviews(_ isHidden: Bool) {
        arrangedSubviews.forEach {
            $0.isHidden = isHidden
        }
    }
    
    // MARK: - Variadic Function
    // Improve code readability and flexibility by using variadic function instead of a traditional array
    // Consider opting for the variadic approach for a more streamlined and expressive coding experience
    
    /**
     - Adds multiple UIViews to a UIStackView
     - Consider this approach for more concise and expressive code
     */
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
    
    /**
     - Inserts UIViews into a UIStackView at a specified index
     */
    func insertArrangedSubviews(_ views: UIView..., at index: Int) {
        views.enumerated().forEach {
            insertArrangedSubview($0.element, at: index + $0.offset)
        }
    }
    
    /**
     - Inserts UIViews into a UIStackView after a specific view
     */
    func insertArrangedSubviews(_ views: UIView..., after view: UIView) {
        guard let index = arrangedSubviews.firstIndex(of: view) else { return }
        let indexToInsert = index + 1
        views.enumerated().forEach {
            insertArrangedSubview($0.element, at: indexToInsert + $0.offset)
        }
    }
}
