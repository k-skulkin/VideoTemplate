
import AVFoundation
import CoreMedia
import Foundation
import UIKit

final class TemplateViewModel: ObservableObject {

	// MARK: - Properties

	// MARK: Public

	@Published private(set) var isShareButtonVisible = false
	@Published private(set) var content: TemplateViewContent = .progressIndicator

	// MARK: Private

	private let fileManager: FileManager
	private let videoMerger: VideoMerger
	private let videoWriterActionsFactory: VideoWriterActionsFactory

	private var assetUrl: URL?

	// MARK: Input

	private let templateActions: [TemplateAction]
	private let templateAudio: TemplateAudio
	private let templateSize: CGSize

	// MARK: - Init

	init(
		fileManager: FileManager,
		templateInfoFactory: TemplateInfoFactory,
		videoMerger: VideoMerger,
		videoWriterActionsFactory: VideoWriterActionsFactory,
		input: TemplateContract.Input,
		output: TemplateContract.Output
	) {
		self.fileManager = fileManager
		self.videoMerger = videoMerger
		self.videoWriterActionsFactory = videoWriterActionsFactory

		let info = templateInfoFactory.info(by: input.template)

		templateActions = info.actions
		templateAudio = info.audio
		templateSize = info.size
	}

	// MARK: - Public methods

	public func onAppear() {
		Task(priority: .background) {
			let actions = try await videoWriterActionsFactory.prepareActions(
				templateActions: templateActions,
				templateSize: templateSize
			)

			DispatchQueue.main.async { [weak self] in
				self?.fetchVideo(with: actions)
			}
		}
	}

	public func onShareButton() {
		guard let assetUrl else { return }

		let activityVC = UIActivityViewController(
			activityItems: [assetUrl],
			applicationActivities: nil
		)

		// Not very elegant, but there's no extra time either
		let allScenes = UIApplication.shared.connectedScenes
		let scene = allScenes.first { $0.activationState == .foregroundActive }

		if let windowScene = scene as? UIWindowScene {
			windowScene.keyWindow?.rootViewController?.present(
				activityVC,
				animated: true
			)
		}
	}

}

// MARK: - Private methods

extension TemplateViewModel {

	private func fetchVideo(
		with actions: [VideoWriterAction]
	) {
		guard let videoAssetPath = try? prepareVideoAssetPath()
		else { fatalError("Failed to create path") }

		guard
			let videoWriter = VideoWriter(
				url: URL(filePath: videoAssetPath),
				width: Int(templateSize.width),
				height: Int(templateSize.height),
				sessionStartTime: .zero
			)
		else { fatalError("Failed to create VideoWriter") }

		append(actions: actions, to: videoWriter)
	}

	private func prepareVideoAssetPath() throws -> String {
		let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

		guard let documentDirectory = urls.first
		else { fatalError("Failed to get Document Directory url") }

		let videoOutputUrl = documentDirectory.appendingPathComponent(
			"VideoTemplateWithoutSound.mp4"
		)
		let videoOutputPath = videoOutputUrl.path()

		if fileManager.fileExists(atPath: videoOutputPath) {
			try fileManager.removeItem(at: videoOutputUrl)
		}

		return videoOutputPath
	}

	private func append(
		actions: [VideoWriterAction],
		to videoWriter: VideoWriter
	) {
		let group = DispatchGroup()

		for (index, action) in actions.enumerated() {
			let delay = Double(index) / 10

			group.enter()

			DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
				videoWriter.append(action: action)
				group.leave()
			}
		}

		group.notify(queue: .main) {
			videoWriter.finish { [weak self] asset in
				guard let asset else { fatalError() }

				self?.mergeWithAudio(videoAsset: asset)

			}
		}
	}

	private func mergeWithAudio(
		videoAsset: AVURLAsset
	) {
		guard
			let audioUrl = Bundle.main.url(
			forResource: templateAudio.fileName(),
			withExtension: templateAudio.fileExtension()
		)
		else { return showVideo(at: videoAsset.url) }

		Task(priority: .background) {
			let mergedVideoUrl = try await videoMerger.merge(
				videoUrl: videoAsset.url,
				audioUrl: audioUrl
			)

			await MainActor.run {
				showVideo(at: mergedVideoUrl)
			}
		}
	}

	private func showVideo(at url: URL) {
		content = .video(
			viewModel: VideoPlayerViewModel(
				notificationCenter: .default,
				url: url,
				isRepeating: true,
				avLayerVideoGravity: .resizeAspectFill
			)
		)

		assetUrl = url
		isShareButtonVisible = true
	}

}
