
import UIKit

extension UIImage {

	func adding(
		image: UIImage,
		at position: CGPoint = .zero
	) -> UIImage? {
		UIGraphicsBeginImageContext(size)

		let rect = CGRect(
			origin: .zero,
			size: size
		)

		draw(in: rect)

		image.draw(
			in: CGRect(
				origin: position,
				size: image.size
			),
			blendMode: .normal,
			alpha: 1.0
		)

		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage
	}

}
