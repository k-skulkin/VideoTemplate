
import CoreMedia

final class TemplateInfoFactory {

	// MARK: - Static

	static let shared = TemplateInfoFactory()

	// MARK: - Public methods

	func info(by template: Template) -> TemplateInfo {
		switch template {
		case .casual:
			let duration = 11.0

			return TemplateInfo(
				size: CGSize(width: 1170, height: 1705),
				duration: duration,
				audio: .casual,
				actions: casualActions(duration: duration)
			)
			
		}
	}

}

// MARK: - Private methods

extension TemplateInfoFactory {

	private func casualActions(duration: TimeInterval) -> [TemplateAction] {
		[
			TemplateAction(
				time: CMTimeMake(value: 0, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image1,
						templateImageType: .original
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 50, timescale: 60),
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
				time: CMTimeMake(value: 60, timescale: 60),
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
				time: CMTimeMake(value: 92, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image2,
						templateImageType: .original
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 130, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image2,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image3,
						templateImageType: .person
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 150, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image3,
						templateImageType: .original
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 182, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image3,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image4,
						templateImageType: .person,
						offset: CGPoint(x: -300, y: -500),
						sizeScale: 1.3
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 192, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image3,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image4,
						templateImageType: .person,
						offset: CGPoint(x: -150, y: -250),
						sizeScale: 1.15
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 202, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image3,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image4,
						templateImageType: .person
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 222, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image4,
						templateImageType: .original
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 256, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image4,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image5,
						templateImageType: .background,
						offset: CGPoint(x: 200, y: 0),
						rotation: .pi / 17,
						sizeScale: 1.05
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 266, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image4,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image5,
						templateImageType: .background,
						offset: CGPoint(x: 200, y: 0),
						rotation: .pi / 17
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 280, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image4,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image5,
						templateImageType: .background,
						offset: CGPoint(x: 200, y: 0),
						rotation: .pi / 17
					),
					TemplateLayer(
						templateImage: .image5,
						templateImageType: .person
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 303, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image5,
						templateImageType: .original
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 340, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image5,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image6,
						templateImageType: .person,
						offset: CGPoint(x: -100, y: -100),
						sizeScale: 1.1
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 350, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image5,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image6,
						templateImageType: .person
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 396, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image6,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .person,
						offset: CGPoint(x: -100, y: -100),
						sizeScale: 1.1
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 406, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image6,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .background
					),
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .person,
						offset: CGPoint(x: -100, y: -100),
						sizeScale: 1.1
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 422, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .original
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 448, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 370, y: -200),
						sizeScale: 0.8
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 457, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 370, y: -200),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 250, y: -600),
						sizeScale: 0.75
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 465, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 370, y: -200),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 250, y: -600),
						sizeScale: 0.75
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: -160, y: 0),
						sizeScale: 0.8
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 473, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 370, y: -200),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 250, y: -600),
						sizeScale: 0.75
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: -160, y: 0),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 0, y: -500),
						sizeScale: 0.75
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 481, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 370, y: -200),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 250, y: -600),
						sizeScale: 0.75
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: -160, y: 0),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 0, y: -500),
						sizeScale: 0.75
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 300, y: 300),
						sizeScale: 0.8
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 489, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image7,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 370, y: -200),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 250, y: -600),
						sizeScale: 0.75
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: -160, y: 0),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 0, y: -500),
						sizeScale: 0.75
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person,
						offset: CGPoint(x: 300, y: 300),
						sizeScale: 0.8
					),
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .person
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 515, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .original
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 553, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image9,
						templateImageType: .background,
						sizeScale: 1.1
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 565, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image8,
						templateImageType: .original
					),
					TemplateLayer(
						templateImage: .image9,
						templateImageType: .background
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 572, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image9,
						templateImageType: .original
					)
				]
			),
			TemplateAction(
				time: CMTimeMake(value: 600, timescale: 60),
				layers: [
					TemplateLayer(
						templateImage: .image9,
						templateImageType: .original
					)
				]
			)
		]
	}

}
