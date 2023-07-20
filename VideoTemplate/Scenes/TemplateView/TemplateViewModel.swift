
import CoreMedia
import Foundation
import UIKit

final class TemplateViewModel: ObservableObject {

	// MARK: - Properties

	// MARK: Public

	@Published private(set) var background: TemplateViewBackground = .color()

	// MARK: Private

	private let backgroundsSeparator: BackgroundsSeparator
	private let fileManager: FileManager

	private let templateImages: [TemplateImage]

	// MARK: Input

	private let templateSize: CGSize
	private let templateActions: [TemplateAction]

	// MARK: - Init

	init(
		backgroundsSeparator: BackgroundsSeparator,
		fileManager: FileManager,
		templateInfoFactory: TemplateInfoFactory,
		input: TemplateContract.Input,
		output: TemplateContract.Output
	) {
		self.backgroundsSeparator = backgroundsSeparator
		self.fileManager = fileManager

		let info = templateInfoFactory.info(by: input.template)

		templateSize = info.size
		templateActions = info.actions

		templateImages = templateActions.map {
			$0.templateImage
		}.uniqued()
	}

	// MARK: - Public methods

	public func onAppear() {
		do {
			try fetchVideo()
		} catch {
			print(error)
		}
	}

	public func onShareButton() {

	}

}

// MARK: - Private methods

extension TemplateViewModel {

	private func fetchVideo() throws {
		let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

		guard let documentDirectory = urls.first
		else { fatalError("Failed to get Document Directory url") }

		let videoOutputUrl = documentDirectory.appendingPathComponent(
			"OutputVideo.mp4"
		)
		let videoOutputPath = videoOutputUrl.path()

		if fileManager.fileExists(atPath: videoOutputPath) {
			do {
				try fileManager.removeItem(at: videoOutputUrl)
			} catch {
				print("Failed to remove item at path: \(videoOutputPath)")
			}
		}

		guard
			let videoWriter = VideoWriter(
				url: videoOutputUrl,
				width: 1170,
				height: 1705,
				sessionStartTime: .zero,
				isRealTime: false,
				queue: .main
			)
		else { fatalError("Failed to create VideoWriter") }

		let assets = try getAssets()

		for action in templateActions {
			guard let asset = assets[action.templateImage] else {
				fatalError("No expected assset")
			}

			videoWriter.add(
				image: asset.getImage(by: action.templateImageType),
				presentationTime: action.time
			)
		}

		videoWriter.finish { [weak self] asset in
			guard let asset else { fatalError() }

			self?.background = .video(
				viewModel: VideoPlayerViewModel(
					notificationCenter: .default,
					url: asset.url,
					isRepeating: true,
					avLayerVideoGravity: .resizeAspectFill
				)
			)
		}
	}

	private func getAssets() throws -> [TemplateAsset] {
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
