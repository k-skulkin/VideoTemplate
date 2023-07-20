
import CoreMedia

final class TemplateInfoFactory {

	static let shared = TemplateInfoFactory()

	// MARK: - Public methods

	func info(by template: Template) -> TemplateInfo {
		switch template {
		case .casual:
			TemplateInfo(
				size: CGSize(width: 1170, height: 1705),
				actions: [
					TemplateAction(
						time: .zero,
						templateImage: .image1,
						templateImageType: .original
					),
					TemplateAction(
						time: CMTimeMake(value: 25, timescale: 60),
						templateImage: .image2,
						templateImageType: .person
					),
					TemplateAction(
						time: CMTimeMake(value: 60, timescale: 60),
						templateImage: .image2,
						templateImageType: .original
					)
				]
			)
		}
	}

}
