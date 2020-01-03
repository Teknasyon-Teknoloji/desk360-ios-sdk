//
//  VideoView.swift
//  Desk360
//
//  Created by samet on 24.12.2019.
//

import UIKit

/// Use `VideoView` to play a video without controls.
open class VideoView: UIView {

	/// `BackgroundVideoPlayer`
	open var player: BackgroundVideoPlayer?

	/// Prepare the view for playing.
	///
	/// - Parameter options: Playback options.
	open func prepareForPlaying(options: BackgroundVideoPlayer.PlaybackOptions) {
		player = BackgroundVideoPlayer(options: options, view: self)
		player?.prepare()
	}

	/// The background color of the view.
	open override var backgroundColor: UIColor? {
		didSet {
			player?.videoLayer?.backgroundColor = backgroundColor?.cgColor
		}
	}

	/// The bounds rectangle, which describes the view’s location and size in its own coordinate system.
	open override var bounds: CGRect {
		didSet {
			player?.videoLayer?.frame = bounds
		}
	}

}
