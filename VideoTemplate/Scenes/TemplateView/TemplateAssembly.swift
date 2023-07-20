
import SwiftUI

final class TemplateAssembly {

	// MARK: - Static

	static let shared = TemplateAssembly()

	// MARK: - Properties

	private let backgroundsSeparator: BackgroundsSeparator
	private let fileManager: FileManager
	private let templateInfoFactory: TemplateInfoFactory

	// MARK: - Init

	init(
		backgroundsSeparator: BackgroundsSeparator = .shared,
		fileManager: FileManager = .default,
		templateInfoFactory: TemplateInfoFactory = .shared
	) {
		self.backgroundsSeparator = backgroundsSeparator
		self.fileManager = fileManager
		self.templateInfoFactory = templateInfoFactory
	}

}

// MARK: - Assembly

extension TemplateAssembly {

	func assemble(
		input: TemplateContract.Input,
		output: TemplateContract.Output
	) -> some View {
		let viewModel = TemplateViewModel(
			backgroundsSeparator: backgroundsSeparator,
			fileManager: fileManager,
			templateInfoFactory: templateInfoFactory,
			input: input,
			output: output
		)

		return TemplateView(viewModel: viewModel)
	}

}
