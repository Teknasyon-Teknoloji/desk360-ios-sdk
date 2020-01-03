//
//  BackgroundVideoPlayer.swift
//  Desk360
//
//  Created by samet on 24.12.2019.
//

import UIKit
import AVFoundation

/// Use `BackgroundVideoPlayer` to play ambient video in the background of a view controller.
open class BackgroundVideoPlayer: LoopingPlayer {

	/// View to add the player on top of.
	open weak var view: UIView?

	/// `AVPlayerLayer`
	open var videoLayer: AVPlayerLayer?

	/// Playback options.
	private var options: PlaybackOptions?

	/// Create a new `BackgroundVideoPlayer` object.
	///
	/// - Parameters:
	///   - options: Playback options.
	///   - view: View to add the player on top of.
	public required init(options: PlaybackOptions, view: UIView) {
		self.options = options
		self.view = view
		super.init(url: options.url)
	}

	/// Prepare the player for playing.
	open override func prepare() {
		super.prepare()

		if let volume = options?.volume {
			player?.volume = volume
			if volume <= 0 {
				player?.isMuted = true
			}
		}

		player?.allowsExternalPlayback = false

		let layer = AVPlayerLayer(player: player)

		if let aView = view {
			layer.bounds = aView.bounds
			layer.frame = aView.frame
			layer.shouldRasterize = true
			aView.layer.insertSublayer(layer, at: 0)
		}

		layer.videoGravity = .resizeAspectFill
		videoLayer = layer
		view?.layer.insertSublayer(videoLayer!, at: 0)
	}

}

// MARK: - Helpers
public extension BackgroundVideoPlayer {

	/// Playback Options.
	struct PlaybackOptions {

		/// Video URL, remote or local.
		public var url: URL

		/// Playback volume.
		public let volume: Float

		/// Create a new `PlaybackOptions` object.
		///
		/// - Parameters:
		///   - url: Video URL, remote or local.
		///   - volume: Playback volume.
		public init(url: URL, volume: Float = 0.35) {
			self.url = url
			self.volume = volume
		}

	}

}
