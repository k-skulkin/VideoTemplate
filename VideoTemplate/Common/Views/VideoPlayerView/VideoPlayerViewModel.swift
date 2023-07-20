
import AVKit
import Foundation

final class VideoPlayerViewModel: ObservableObject {

	// MARK: - Properies

	let player: AVPlayer
	let avLayerVideoGravity: AVLayerVideoGravity

	// MARK: Private

	private let notificationCenter: NotificationCenter

	// MARK: - Init

	init(
		notificationCenter: NotificationCenter,
		url: URL,
		isRepeating: Bool,
		avLayerVideoGravity: AVLayerVideoGravity
	) {
		self.notificationCenter = notificationCenter
		self.avLayerVideoGravity = avLayerVideoGravity

		player = AVPlayer(url: url)

		if isRepeating {
			setupBindings()
		}

		player.play()
	}

	deinit {
		removeBindings()
	}

	// MARK: - Public methods

	func play() {
		player.play()
	}

	func pause() {
		player.pause()
	}

}

// MARK: - Private methods

extension VideoPlayerViewModel {

	private func setupBindings() {
		notificationCenter.addObserver(
			forName: .AVPlayerItemDidPlayToEndTime,
			object: player.currentItem,
			queue: nil
		) { [weak self] _ in
			self?.player.seek(to: .zero)
			self?.player.play()
		}
	}

	private func removeBindings() {
		notificationCenter.removeObserver(
			self,
			name: .AVPlayerItemDidPlayToEndTime,
			object: player.currentItem
		)
	}

}
