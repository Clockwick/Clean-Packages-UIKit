import Foundation
/// Enumeration representing various radius values.
/// - none: No radius (0 points).
/// - xs2: Extra-extra-small radius (2 points).
/// - xs: Extra-small radius (4 points).
/// - sm: Small radius (8 points).
/// - md: Medium radius (16 points).
/// - lg: Large radius (20 points).
/// - xl: Extra-large radius (24 points).
/// - xl2: Double extra-large radius (32 points).
/// - full: Full radius (999 points).
public enum Radius {
    /// No radius (0 points).
    public static let none: CGFloat = 0
    
    /// Extra-extra-small radius (2 points).
    public static let xs2: CGFloat = 2
    
    /// Extra-small radius (4 points).
    public static let xs: CGFloat = 4
    
    /// Small radius (8 points).
    public static let sm: CGFloat = 8
    
    /// Medium radius (16 points).
    public static let md: CGFloat = 16
    
    /// Large radius (20 points).
    public static let lg: CGFloat = 20
    
    /// Extra-large radius (24 points).
    public static let xl: CGFloat = 24
    
    /// Double extra-large radius (32 points).
    public static let xl2: CGFloat = 32
    
    /// Full radius (999 points).
    public static let full: CGFloat = 999
}
