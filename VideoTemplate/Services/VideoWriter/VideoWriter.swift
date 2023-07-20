//
//  VideoMaker.swift
//  TestVideoTemplate
//
//  Created by Skulkin Kirill on 20.07.2023.
//

import AVFoundation
import Foundation
import UIKit

final class VideoWriter {

	fileprivate static var ciContext = CIContext() // we reuse a single context for performance reasons

	private var writer: AVAssetWriter
	private var writerInput: AVAssetWriterInput
	private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor

	init?(
		url: URL,
		width: Int,
		height: Int,
		sessionStartTime: CMTime,
		isRealTime: Bool = false
	) {
		let outputSettings: [String: Any] = [
			AVVideoCodecKey: AVVideoCodecType.hevc,
			AVVideoWidthKey: width,
			AVVideoHeightKey: height,
		]
		let input = AVAssetWriterInput(
			mediaType: .video,
			outputSettings: outputSettings
		)
		input.expectsMediaDataInRealTime = isRealTime
		
		guard
			let writer = try? AVAssetWriter(
				url: url,
				fileType: .mp4
			),
			writer.canAdd(input),
			sessionStartTime != .invalid
		else { return nil }

		let sourceBufferAttributes: [String: Any] = [
			String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32ARGB,
			String(kCVPixelBufferWidthKey): width,
			String(kCVPixelBufferHeightKey): height,
		]
		pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
			assetWriterInput: input,
			sourcePixelBufferAttributes: sourceBufferAttributes
		)

		writer.add(input)
		writer.startWriting()
		writer.startSession(atSourceTime: sessionStartTime)

		if let error = writer.error {
			print("VideoWriter init: ERROR - \(error)")
			return nil
		}

		self.writer = writer
		self.writerInput = input
	}

	@discardableResult
	func append(action: VideoWriterAction) -> Bool {
		add(image: action.image, presentationTime: action.time)
	}

	func finish(
		in queue: DispatchQueue = .main,
		completionBlock: ((AVURLAsset?) -> Void)? = nil
	) {
		writerInput.markAsFinished()

		writer.finishWriting {
			queue.async {
				guard self.writer.status == .completed else {
					print("VideoWriter finish: error in finishWriting - \(String(describing: self.writer.error))")
					completionBlock?(nil)
					return
				}

				let asset = AVURLAsset(
					url: self.writer.outputURL,
					options: [
						AVURLAssetPreferPreciseDurationAndTimingKey: true
					]
				)
				let duration = CMTimeGetSeconds(asset.duration)
				// can check for minimum duration here (ie. consider a failure if too short)
				print("VideoWriter: finishWriting() complete, duration=\(duration)")

				completionBlock?(asset)
			}
		}
	}

}

// MARK: - Private methods

extension VideoWriter {

	@discardableResult
	func add(image: UIImage, presentationTime: CMTime) -> Bool {
		if writerInput.isReadyForMoreMediaData == false {
			return false
		}

		if
			pixelBufferAdaptor.appendPixelBufferForImage(
				image,
				presentationTime: presentationTime
		) {
			return true
		}

		return false
	}

}

// MARK: - Private extensions

private extension AVAssetWriterInputPixelBufferAdaptor {

	func appendPixelBufferForImage(_ image: UIImage, presentationTime: CMTime) -> Bool {
		var appendSucceeded = false

		autoreleasepool {
			guard let pixelBufferPool = pixelBufferPool else {
				// writer can have error:  writer.error=\(String(describing: self.writer.error))
				print("appendPixelBufferForImage: ERROR - missing pixelBufferPool")
				return
			}

			let pixelBufferPointer = UnsafeMutablePointer<CVPixelBuffer?>
				.allocate(capacity: 1)
			let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(
				kCFAllocatorDefault,
				pixelBufferPool,
				pixelBufferPointer
			)

			if
				let pixelBuffer = pixelBufferPointer.pointee,
				status == 0
			{
				pixelBuffer.fillPixelBufferFromImage(image)
				appendSucceeded = append(pixelBuffer, withPresentationTime: presentationTime)

				if !appendSucceeded {
					// If a result of NO is returned, clients can check the value of AVAssetWriter.status to determine whether the writing operation completed, failed, or was cancelled.  If the status is AVAssetWriterStatusFailed, AVAsset.error will contain an instance of NSError that describes the failure.
					print("VideoWriter appendPixelBufferForImage: ERROR appending")
				}
				pixelBufferPointer.deinitialize(count: 1)
			} else {
				print("VideoWriter appendPixelBufferForImage: ERROR - Failed to allocate pixel buffer from pool, status=\(status)") // -6680 = kCVReturnInvalidPixelFormat
			}

			pixelBufferPointer.deallocate()
		}
		return appendSucceeded
	}
}

private extension CVPixelBuffer {

	func fillPixelBufferFromImage(_ image: UIImage) {
		CVPixelBufferLockBaseAddress(self, [])

		if let cgImage = image.cgImage {
			guard
				let context = CGContext(
					data: CVPixelBufferGetBaseAddress(self),
					width: Int(image.size.width),
					height: Int(image.size.height),
					bitsPerComponent: 8,
					bytesPerRow: CVPixelBufferGetBytesPerRow(self),
					space: CGColorSpaceCreateDeviceRGB(),
					bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
				)
			else {
				assert(false)
				return
			}

			context.draw(
				cgImage,
				in: CGRect(
					x: 0,
					y: 0,
					width: image.size.width,
					height: image.size.height
				)
			)
		} else if let ciImage = image.ciImage {
			VideoWriter.ciContext.render(ciImage, to: self)
		}

		CVPixelBufferUnlockBaseAddress(self, [])
	}

}
