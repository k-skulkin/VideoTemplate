
import UIKit

extension UIImage {

	func resized(to size: CGSize, scale: CGFloat = 1) -> UIImage {
		let format = UIGraphicsImageRendererFormat.default()
		format.scale = scale

		return UIGraphicsImageRenderer(
			size: size,
			format: format
		).image { _ in
			autoreleasepool {
				draw(in: CGRect(origin: .zero, size: size))
			}
		}
	}

	func resized(toHeight height: CGFloat) -> UIImage {
		let k = height / size.height
		let size = CGSize(width: size.width * k, height: height)
		return resized(to: size)
	}

	func resized(toWidth width: CGFloat) -> UIImage {
		let k = width / size.width
		let size = CGSize(width: width, height: size.height * k)
		return resized(to: size)
	}

	func resized(to maxSize: CGFloat) -> UIImage {
		let ratio = maxSize / max(size.width, size.height)
		let ratioImage = resized(to: CGSize(width: size.width * ratio, height: size.height * ratio))
		return ratioImage
	}

}
