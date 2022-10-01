import Foundation

extension Array where Element == String {
   mutating func appendUniqueElements(_ otherArray: [String]) {
    for s in otherArray {
      if self.contains(s) == false {
        self.append(s)
      }
    }
  }
}
