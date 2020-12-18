//
//  MusicPlayer.swift
//  Oasis
//  Helper class to handle the background music of the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source: https://codewithchris.com/avaudioplayer-tutorial/
//  Music: Link: https://incompetech.filmmusic.io/song/5759-blippy-trance
//         License: http://creativecommons.org/licenses/by/4.0/
//
//  Created by Greeley Lindberg and William Parlan on 6/4/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class MusicPlayer {
    // MARK: - Local Variables
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?

    // MARK: - Local Functions
    /**
     Helper Function to start playing background music.
     */
    func startBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "blippy-loop", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            catch {
                print(error)
            }
        }
    }
    /**
     Helper functino to stop playing backgroun music
     */
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}
