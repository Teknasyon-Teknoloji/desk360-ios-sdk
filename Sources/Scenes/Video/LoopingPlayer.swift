//
//  LoopingPlayer.swift
//  Desk360
//
//  Created by samet on 24.12.2019.
//

import UIKit
import AVKit

/// Player that loops it's playback using `AVPlayerLooper`
open class LoopingPlayer {

	/// `AVPlayerItem`
	open var item: AVPlayerItem?

	/// `AVQueuePlayer`
	open var player: AVQueuePlayer?

	/// `AVPlayerLooper`
	open var looper: AVPlayerLooper?

	/// Media URL (can be remote or local url).
	open var url: URL

	/// Video dimensions (This value is in the prepare method).
	private(set) public var videoSize: CGSize?

	/// Create a new `LoopingPlayer` from URL.
	///
	/// - Parameter url: Media URL (can be remote or local url).
	public init(url: URL) {
		self.url = url
	}

	/// Prepare the player.
	open func prepare() {
		guard player == nil else { return }

		player = AVQueuePlayer()
		item = AVPlayerItem(url: url)
		looper = AVPlayerLooper(player: player!, templateItem: item!)

		guard let track = item?.asset.tracks(withMediaType: .video).first else { return }
		let size = track.naturalSize.applying(track.preferredTransform)
		videoSize = CGSize(width: abs(size.width), height: abs(size.height))
	}

	/// Play.
	open func play() {
		prepare()
		player?.play()
	}

	/// Pause.
	open func pause() {
		player?.pause()
	}

	/// Deinitialize the object.
	deinit {
		item = nil
		player = nil
		looper = nil
	}

}
