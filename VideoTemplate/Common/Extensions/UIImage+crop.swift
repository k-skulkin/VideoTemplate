
import UIKit

extension UIImage {

	func crop(to rect: CGRect) -> UIImage? {
		guard let cgImage = cgImage?.cropping(to: rect)
		else { return nil }

		return UIImage(cgImage: cgImage)
	}

}
