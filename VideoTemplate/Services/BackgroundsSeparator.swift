
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

final class BackgroundsSeparator {

	// MARK: - Static

	static let shared = BackgroundsSeparator(
		personSegmentator: .shared
	)

	// MARK: - Properties

	private let personSegmentator: PersonSegmentator

	// MARK: - Init

	init(
		personSegmentator: PersonSegmentator
	) {
		self.personSegmentator = personSegmentator
	}

	// MARK: - Public methods

	func separateBackground(from image: UIImage) throws -> Response {
		guard let cgImage = image.cgImage else {
			throw ProcessError.failedRenderingCIImage
		}

		let ciImage = CIImage(cgImage: cgImage)
		let mask = try personSegmentator.segment(image: cgImage)
		let invertedMask = try invertColors(at: mask)

		let persons = try apply(mask: mask, on: ciImage)
		let background = try apply(mask: invertedMask, on: ciImage)

		return Response(
			persons: UIImage(ciImage: persons),
			background: UIImage(ciImage: background)
		)
	}

}

// MARK: - Response

extension BackgroundsSeparator {

	struct Response {
		let persons: UIImage
		let background: UIImage
	}

}

// MARK: - ProcessError

extension BackgroundsSeparator {

	enum ProcessError: Error {
		case failedRenderingCIImage
		case failedRenderingCGImage
		case failedInvertingColors
		case failedMasking
	}

}

// MARK: - Private methods

extension BackgroundsSeparator {

	private func apply(mask: CIImage, on image: CIImage) throws -> CIImage {
		let filter = CIFilter.blendWithMask()

		filter.inputImage = image
		filter.maskImage = mask

		guard
			let ciImage = filter.outputImage
		else { throw ProcessError.failedMasking }

		return ciImage
	}

	private func invertColors(at image: CIImage) throws -> CIImage {
		let filter = CIFilter.colorInvert()
		filter.inputImage = image

		guard let output = filter.outputImage
		else { throw ProcessError.failedInvertingColors }

		return output
	}

}
