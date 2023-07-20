
import UIKit

extension UIImage {

	/// Places the first image below the second image while keeping the size.
	/// - Parameters:
	///   - backgroundImage: The image to be placed on the background. The size changes to match the main image.
	///   - image: The main image that is displayed on the top layer.
	static func place(image backgroundImage: UIImage, belowImage image: UIImage) -> UIImage? {
		let width = image.size.width
		let height = image.size.height

		let backgroundX: CGFloat
		let backgroundY: CGFloat
		let backgroundHeight: CGFloat
		let backgroundWidth: CGFloat
		let resizedBackgroundImage: UIImage

		if height >= width {
			resizedBackgroundImage = backgroundImage.resized(toHeight: height)
			backgroundHeight = resizedBackgroundImage.size.height
			backgroundWidth = width
			backgroundX = (resizedBackgroundImage.size.width - width) / 2
			backgroundY = 0
		} else {
			resizedBackgroundImage = backgroundImage.resized(toWidth: width)
			backgroundWidth = resizedBackgroundImage.size.width
			backgroundHeight = height
			backgroundX = 0
			backgroundY = (resizedBackgroundImage.size.height - height) / 2
		}

		let backgroundImageRect = CGRect(
			x: backgroundX,
			y: backgroundY,
			width: backgroundWidth,
			height: backgroundHeight
		)

		guard
			let croppedBackgroundImage = resizedBackgroundImage.crop(
				to: backgroundImageRect
			)
		else { return image }

		return croppedBackgroundImage.adding(image: image)
	}

}
