
import AVFoundation
import UIKit

public class PlayerView: UIView {

	// MARK: - Overrides

	public override class var layerClass: AnyClass {
		return AVPlayerLayer.self
	}

	var playerLayer: AVPlayerLayer? {
		return layer as? AVPlayerLayer
	}

}
