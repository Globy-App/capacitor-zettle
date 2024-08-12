import Foundation

@objc public class Zettle: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
