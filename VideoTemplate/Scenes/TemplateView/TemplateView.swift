
import SwiftUI

struct TemplateView: View {

	// MARK: - Properties

	@ObservedObject private var viewModel: TemplateViewModel

	// MARK: - Init

	init(viewModel: TemplateViewModel) {
		self.viewModel = viewModel
	}

	// MARK: - Body

	var body: some View {
		ZStack(alignment: .bottom) {
			backgroundView()

			shareButton()
				.padding(.bottom, 32)
				.padding(.horizontal)
		}
		.ignoresSafeArea()
		.onAppear {
			viewModel.onAppear()
		}
	}

}

// MARK: - Private methods

extension TemplateView {

	private func shareButton() -> some View {
		Button(
			action: {
				viewModel.onShareButton()
			},
			label: {
				ZStack {
					Color.orange

					Text("Share")
						.tint(.white)
						.font(.headline)
				}
			}
		)
		.clipShape(Capsule())
		.frame(width: 320, height: 56)
	}

	@ViewBuilder
	private func backgroundView() -> some View {
		switch viewModel.background {
		case let .color(color):
			color

		case let .video(viewModel):
			VideoPlayerView(viewModel: viewModel)

		}
	}

}

// MARK: - Previews

struct TemplateViewPreviews: PreviewProvider {

	static var previews: some View {
		TemplateAssembly.shared.assemble(
			input: TemplateContract.Input(template: .casual),
			output: TemplateContract.Output()
		)
	}

}
