
import Foundation
import UIKit
import Vision

final class PersonSegmentator {

	// MARK: - Static

	static let shared = PersonSegmentator()

	// MARK: - Public methods

	func segment(image: CGImage) throws -> CIImage {
		let request = VNGeneratePersonSegmentationRequest()
		request.qualityLevel = .accurate

		#if targetEnvironment(simulator)
		request.usesCPUOnly = true
		#endif

		let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
		try requestHandler.perform([request])
		let results = request.results

		guard
			let maskPixelBuffer = results?.first?.pixelBuffer
		else { throw ProcessError.failedProcessing }

		var mask = CIImage(cvPixelBuffer: maskPixelBuffer)
		let scaleX = CGFloat(image.width) / mask.extent.width
		let scaleY = CGFloat(image.height) / mask.extent.height

		mask = mask.transformed(
			by: CGAffineTransform(scaleX: scaleX, y: scaleY)
		)

		return mask
	}

}

// MARK: - ProcessError

extension PersonSegmentator {

	enum ProcessError: Error {
		case failedProcessing
		case failedCGImageRendering
	}

}
