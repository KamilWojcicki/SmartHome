import Foundation

extension String {
    public var localized: String {
        NSLocalizedString(self, bundle: .module, value: self, comment: "")
    }
}
