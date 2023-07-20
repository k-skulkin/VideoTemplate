
import Foundation

public extension Sequence where Element: Hashable {

	/// Returns array with only unique elements.
	func uniqued() -> [Element] {
		var set = Set<Element>()

		return filter {
			set.insert($0).inserted
		}
	}

}
