//
//  PublicAudioImageProperties.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 29/04/24.
//

import Foundation
import AVFAudio


@Observable class PublicAudioImageProperties {
    static let shared = PublicAudioImageProperties()
    
    var isReadyToPlayFull = false
    var isLoading = false
    var audioFileSelectedAndAdded = false
    var isPlaying: Bool = false {
        didSet {
            self.setUpTimer()
        }
    }
    var durationTime = TimeInterval(0)
    var currentTime = TimeInterval(0)
    
    var playOnFullScreen = false
    
    var showOnFullScreenAudioPlayer = true
    
    @ObservationIgnored var audioPlayer = AVAudioPlayer()

    func setUpTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { Timer in
            print("1/2 seconds passed")
            self.updateCurrentTime()
        }
        

    }
    
    func updateCurrentTime() {
        self.currentTime = self.audioPlayer.currentTime
        if self.isPlaying {
            setUpTimer()
        }
    }
    
//    func audioPlayerDid

}



class AVAudioPlayerDeleteFunction: NSObject, AVAudioPlayerDelegate {
    static let shared = AVAudioPlayerDeleteFunction()
    
    override init() {
        super.init()
//        PublicAudioImageProperties.shared.audioPlayer.delegate = self
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished audio playing....")
        PublicAudioImageProperties.shared.isPlaying = false
    }
}
