
import UIKit

enum TemplateImage: String {
	case image1, image2, image3
	case image4, image5, image6
	case image7, image8
}

// MARK: - Public Extensions

extension TemplateImage {

	var uiImage: UIImage {
		guard let image = UIImage(named: rawValue)
		else { fatalError() }

		return image
	}

}
