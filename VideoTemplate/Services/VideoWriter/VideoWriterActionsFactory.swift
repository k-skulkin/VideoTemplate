
import UIKit

final class VideoWriterActionsFactory {

	static let shared = VideoWriterActionsFactory(
		backgroundsSeparator: .shared
	)

	// MARK: - Properties

	// MARK: Private

	private let backgroundsSeparator: BackgroundsSeparator

	// MARK: - Init

	init(backgroundsSeparator: BackgroundsSeparator) {
		self.backgroundsSeparator = backgroundsSeparator
	}

	// MARK: - Public methods

	func prepareActions(
		templateActions: [TemplateAction],
		templateSize: CGSize
	) async throws -> [VideoWriterAction] {
		let templateImages = templateActions.map { action in
			action.layers.map { layer in
				layer.templateImage
			}
		}.joined().uniqued()
		let assets = try getAssets(from: templateImages)
		var videoWriterActions = [VideoWriterAction]()

		for action in templateActions {
			guard
				let image = prepareImage(
					for: action,
					using: assets,
					with: templateSize
				)
			else { fatalError("Failed to render asset") }

			videoWriterActions.append(
				VideoWriterAction(
					image: image,
					time: action.time
				)
			)
		}

		return videoWriterActions
	}

}

// MARK: - Private methods

private extension VideoWriterActionsFactory {

	private func getAssets(
		from templateImages: [TemplateImage]
	) throws -> [TemplateAsset] {
		try templateImages.map { templateImage in
			let original = templateImage.uiImage
			let response = try backgroundsSeparator.separateBackground(
				from: original
			)

			return TemplateAsset(
				original: original,
				person: response.persons,
				background: response.background,
				templateImage: templateImage
			)
		}
	}

	private func prepareImage(
		for action: TemplateAction,
		using assets: [TemplateAsset],
		with size: CGSize
	) -> UIImage? {
		guard var image = image(size: size)
		else { return nil }

		for layer in action.layers {
			guard let asset = assets[layer.templateImage]
			else { fatalError("No expected assset") }

			let usedImage = asset.getImage(
				by: layer.templateImageType
			)

			guard
				let mergedImage = image.adding(image: usedImage, at: layer.offset)
			else { fatalError("No expected assset") }

			image = mergedImage
		}

		return image
	}

	private func image(
		size: CGSize,
		color: UIColor = .clear,
		scale: CGFloat = UIScreen.main.scale,
		opaque: Bool = false
	) -> UIImage? {
		let rect = CGRectMake(0, 0, size.width, size.height)

		UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
		color.set()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}

}

// MARK: - Private extension

private extension Array where Element == TemplateAsset {

	subscript(type: TemplateImage) -> TemplateAsset? {
		guard
			let processedImage = first(
				where: { $0.templateImage == type }
			)
		else { return nil }

		return processedImage
	}

}
