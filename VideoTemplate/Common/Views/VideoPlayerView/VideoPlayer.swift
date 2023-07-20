
import AVKit
import SwiftUI

struct VideoPlayerView {

	// MARK: - Properies

	@ObservedObject private var viewModel: VideoPlayerViewModel

	// MARK: - Init

	init(viewModel: VideoPlayerViewModel) {
		self.viewModel = viewModel
	}

}

// MARK: - UIViewControllerRepresentable

extension VideoPlayerView: UIViewRepresentable {

	func makeUIView(context: Context) -> PlayerView {
		let playerView = PlayerView()

		playerView.playerLayer?.player = viewModel.player
		playerView.playerLayer?.videoGravity = viewModel.avLayerVideoGravity

		return playerView
	}

	func updateUIView(_ uiView: PlayerView, context: Context) { }

}
