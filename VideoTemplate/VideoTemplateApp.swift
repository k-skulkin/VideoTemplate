
import SwiftUI

@main
struct VideoTemplateApp: App {

	// MARK: - Properties

	private let templateAssembly = TemplateAssembly.shared

	// MARK: - Body

    var body: some Scene {
        WindowGroup {
			templateAssembly.assemble(
				input: TemplateContract.Input(template: .casual),
				output: TemplateContract.Output()
			)
        }
    }

}
