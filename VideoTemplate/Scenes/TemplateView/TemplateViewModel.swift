
import CoreMedia
import Foundation
import UIKit

final class TemplateViewModel: ObservableObject {

	// MARK: - Properties

	// MARK: Public

	@Published private(set) var background: TemplateViewBackground = .progressIndicator

	// MARK: Private

	private let fileManager: FileManager
	private let videoWriterActionsFactory: VideoWriterActionsFactory

	// MARK: Input

	private let templateActions: [TemplateAction]
	private let templateSize: CGSize

	// MARK: - Init

	init(
		fileManager: FileManager,
		templateInfoFactory: TemplateInfoFactory,
		videoWriterActionsFactory: VideoWriterActionsFactory,
		input: TemplateContract.Input,
		output: TemplateContract.Output
	) {
		self.fileManager = fileManager
		self.videoWriterActionsFactory = videoWriterActionsFactory

		let info = templateInfoFactory.info(by: input.template)

		templateActions = info.actions
		templateSize = info.size
	}

	// MARK: - Public methods

	public func onAppear() {
		Task(priority: .background) {
			let actions = try await videoWriterActionsFactory.prepareActions(
				templateActions: templateActions,
				templateSize: templateSize
			)

			DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
				self?.fetchVideo(with: actions)
			}
		}
	}

	public func onShareButton() {
		
	}

}

// MARK: - Private methods

extension TemplateViewModel {

	private func fetchVideo(
		with actions: [VideoWriterAction]
	) {
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
				width: Int(templateSize.width),
				height: Int(templateSize.height),
				sessionStartTime: .zero
			)
		else { fatalError("Failed to create VideoWriter") }

		for action in actions {
			videoWriter.add(
				image: action.image,
				presentationTime: action.time
			)
		}

		videoWriter.finish(
			in: .main
		) { [weak self] asset in
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

}
