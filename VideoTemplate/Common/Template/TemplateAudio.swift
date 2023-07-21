
import Foundation

enum TemplateAudio {
	case casual
}

// MARK: - Public methods

extension TemplateAudio {

	func fileName() -> String {
		switch self {
		case .casual:
			return "TemplateCasualAudio"
			
		}
	}

	func fileExtension() -> String {
		switch self {
		case .casual:
			return "m4a"

		}
	}

}
