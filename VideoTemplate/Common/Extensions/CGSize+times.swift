
import Foundation

extension CGSize {

	static func * (lhs: CGSize, rhs: Double) -> CGSize {
		CGSize(
			width: lhs.width * rhs,
			height: lhs.height * rhs
		)
	}

}
