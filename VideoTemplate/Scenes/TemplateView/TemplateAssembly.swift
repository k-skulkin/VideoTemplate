
import SwiftUI

final class TemplateAssembly {

	// MARK: - Static

	static let shared = TemplateAssembly(
		fileManager: .default,
		templateInfoFactory: .shared,
		videoMerger: .shared,
		videoWriterActionsFactory: .shared
	)

	// MARK: - Properties

	private let fileManager: FileManager
	private let templateInfoFactory: TemplateInfoFactory
	private let videoMerger: VideoMerger
	private let videoWriterActionsFactory: VideoWriterActionsFactory

	// MARK: - Init

	init(
		fileManager: FileManager,
		templateInfoFactory: TemplateInfoFactory,
		videoMerger: VideoMerger,
		videoWriterActionsFactory: VideoWriterActionsFactory
	) {
		self.fileManager = fileManager
		self.templateInfoFactory = templateInfoFactory
		self.videoMerger = videoMerger
		self.videoWriterActionsFactory = videoWriterActionsFactory
	}

}

// MARK: - Assembly

extension TemplateAssembly {

	func assemble(
		input: TemplateContract.Input,
		output: TemplateContract.Output
	) -> some View {
		let viewModel = TemplateViewModel(
			fileManager: fileManager,
			templateInfoFactory: templateInfoFactory,
			videoMerger: videoMerger,
			videoWriterActionsFactory: videoWriterActionsFactory,
			input: input,
			output: output
		)

		return TemplateView(viewModel: viewModel)
	}

}
