
/// Example usage:
/// let dateString1 = "2024-02-19"
/// let date1 = dateString1.toDate(format: "yyyy-MM-dd")
///
/// let dateString2 = "19/02/2024 15:30"
/// let date2 = dateString2.toDate(format: "dd/MM/yyyy HH:mm")
///
/// // Using multiple formats
/// let dateString3 = "2024-02-19"
/// let formats = ["yyyy-MM-dd", "dd/MM/yyyy", "MM-dd-yyyy"]
/// let date3 = dateString3.toDate(formats: formats)
///
/// // Using different timezone and locale
/// let dateString4 = "2024-02-19 15:30"
/// let date4 = dateString4.toDate(
///   format: "yyyy-MM-dd HH:mm",
///   timezone: TimeZone(identifier: "UTC")!,
///   locale: Locale(identifier: "en_US")
/// )

import Foundation

public extension String {
  /// Converts string to Date using specified format
  /// - Parameters:
  ///   - format: Date format string (e.g. "yyyy-MM-dd", "dd/MM/yyyy HH:mm")
  ///   - timezone: TimeZone for parsing (default is current)
  ///   - locale: Locale for parsing (default is current)
  /// - Returns: Optional Date if conversion succeeds
  func toDate(format: String,
              timezone: TimeZone = .current,
              locale: Locale = .current) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.timeZone = timezone
    formatter.locale = locale
    return formatter.date(from: self)
  }
  
  /// Converts string to Date using multiple possible formats
  /// - Parameters:
  ///   - formats: Array of possible date format strings
  ///   - timezone: TimeZone for parsing (default is current)
  ///   - locale: Locale for parsing (default is current)
  /// - Returns: Optional Date if any format succeeds
  func toDate(formats: [String],
              timezone: TimeZone = .current,
              locale: Locale = .current) -> Date? {
    let formatter = DateFormatter()
    formatter.timeZone = timezone
    formatter.locale = locale
    
    for format in formats {
      formatter.dateFormat = format
      if let date = formatter.date(from: self) {
        return date
      }
    }
    return nil
  }
}
