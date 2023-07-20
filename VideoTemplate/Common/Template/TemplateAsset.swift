
import UIKit

struct TemplateAsset {

	let original: UIImage
	let person: UIImage
	let background: UIImage
	let templateImage: TemplateImage

	func getImage(by type: TemplateImageType) -> UIImage {
		switch type {
		case .original:
			return original

		case .person:
			return person

		case .background:
			return background

		}
	}

}
