//
//  PlayerView.swift
//  Desk360
//
//  Created by Mustafa Yazgülü on 2.10.2020.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

/// `PlayerView`
class PlayerView: UIView {
	
	/// Returns the class used to create the layer for instances of this class.
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
	
	/// Player Layer
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
	
	/// Player
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}
