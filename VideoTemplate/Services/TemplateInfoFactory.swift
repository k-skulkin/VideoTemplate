
import CoreMedia

final class TemplateInfoFactory {

	static let shared = TemplateInfoFactory()

	// MARK: - Public methods

	func info(by template: Template) -> TemplateInfo {
		switch template {
		case .casual:
			let duration = 11.0

			return TemplateInfo(
				size: CGSize(width: 1170, height: 1705),
				duration: duration,
				actions: [
					TemplateAction(
						time: .zero,
						layers: [
							TemplateLayer(
								templateImage: .image1,
								templateImageType: .original
							)
						]
					),
					TemplateAction(
						time: CMTimeMakeWithSeconds(0.5, preferredTimescale: Int32(duration)),
						layers: [
							TemplateLayer(
								templateImage: .image1,
								templateImageType: .original
							),
							TemplateLayer(
								templateImage: .image2,
								templateImageType: .person,
								offset: CGPoint(x: 50, y: -50)
							)
						]
					),
					TemplateAction(
						time: CMTimeMakeWithSeconds(1, preferredTimescale: Int32(duration)),
						layers: [
							TemplateLayer(
								templateImage: .image1,
								templateImageType: .original
							),
							TemplateLayer(
								templateImage: .image2,
								templateImageType: .background
							),
							TemplateLayer(
								templateImage: .image2,
								templateImageType: .person,
								offset: CGPoint(x: 50, y: -50)
							)
						]
					),
					TemplateAction(
						time: CMTimeMakeWithSeconds(1.5, preferredTimescale: Int32(duration)),
						layers: [
							TemplateLayer(
								templateImage: .image2,
								templateImageType: .original
							)
						]
					)
				]
			)
			
		}
	}

}
