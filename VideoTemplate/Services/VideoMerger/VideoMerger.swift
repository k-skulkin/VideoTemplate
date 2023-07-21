
import UIKit
import AVFoundation
import AVKit
import AssetsLibrary

final class VideoMerger {

	// MARK: - Static

	static let srared = VideoMerger()

	// MARK: - Public methods

	/// Merges video and sound.
	/// - Parameters:
	///   - videoUrl: URL to video file
	///   - audioUrl: URL to audio file
	func merge(
		videoUrl: URL,
		audioUrl: URL
	) async throws -> URL {
		let mixComposition = AVMutableComposition()
		var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
		var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()

		let videoAsset = AVAsset(url: videoUrl)
		let audioAsset = AVAsset(url: audioUrl)

		guard
			let compositionAddVideo = mixComposition.addMutableTrack(
				withMediaType: .video,
				preferredTrackID: kCMPersistentTrackID_Invalid
			),
			let compositionAddAudio = mixComposition.addMutableTrack(
				withMediaType: .audio,
				preferredTrackID: kCMPersistentTrackID_Invalid
			)
		else { throw VideoMergerError.failedCompositionsCreation }

		guard
			let aVideoAssetTrack = try await videoAsset.loadTracks(
				withMediaType: .video
			).first,
			let aAudioAssetTrack = try await audioAsset.loadTracks(
				withMediaType: .audio
			).first
		else { throw VideoMergerError.failedTracksCreation }

		// Default must have tranformation
		compositionAddVideo.preferredTransform = try await aVideoAssetTrack.load(
			.preferredTransform
		)

		mutableCompositionVideoTrack.append(compositionAddVideo)
		mutableCompositionAudioTrack.append(compositionAddAudio)

		try await mutableCompositionVideoTrack[0].insertTimeRange(
			CMTimeRangeMake(
				start: CMTime.zero,
				duration: aVideoAssetTrack.load(.timeRange).duration
			),
			of: aVideoAssetTrack,
			at: CMTime.zero
		)

		// In my case my audio file is longer then video file so i took videoAsset duration
		// instead of audioAsset duration
		try await mutableCompositionAudioTrack[0].insertTimeRange(
			CMTimeRangeMake(
				start: CMTime.zero,
				duration: aVideoAssetTrack.load(.timeRange).duration
			),
			of: aAudioAssetTrack,
			at: CMTime.zero
		)

		// Exporting
		let savePathUrl: URL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/newVideo.mp4")

		do { // delete old video
			try FileManager.default.removeItem(at: savePathUrl)
		} catch { print(error.localizedDescription) }

		guard
			let assetExport = AVAssetExportSession(
				asset: mixComposition,
				presetName: AVAssetExportPresetHighestQuality
			)
		else { throw VideoMergerError.failedExportSessionCreation }

		assetExport.outputFileType = AVFileType.mp4
		assetExport.outputURL = savePathUrl
		assetExport.shouldOptimizeForNetworkUse = true

		await assetExport.export()

		switch assetExport.status {
		case .completed:
			return savePathUrl

		case .cancelled:
			throw VideoMergerError.exportCancelled

		case .failed:
			throw VideoMergerError.failedCompositionsCreation

		default:
			throw VideoMergerError.unknown
		}
	}

}
