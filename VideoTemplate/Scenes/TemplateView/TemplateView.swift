
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
		ZStack {
			Color.accentColor

			contentView()
		}
		.overlay {
			overlayView()
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
	private func contentView() -> some View {
		switch viewModel.content {
		case .progressIndicator:
			ProgressView()
				.controlSize(.large)
				.progressViewStyle(
					CircularProgressViewStyle(
						tint: .white.opacity(0.5)
					)
				)

		case let .video(viewModel):
			VideoPlayerView(viewModel: viewModel)

		}
	}

	private func overlayView() -> some View {
		ZStack(alignment: .bottom) {
			Color.clear

			if viewModel.isShareButtonVisible {
				shareButton()
					.padding(.bottom, 32)
					.padding(.horizontal)
			}
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
