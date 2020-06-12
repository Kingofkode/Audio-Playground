//
//  ViewController.swift
//  Audio Playground
//
//  Created by Isaiah Suarez on 6/12/20.
//  Copyright © 2020 Isaiah Suarez. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import StoreKit

// Hi Apple Technical Support!

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    let appleMusicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAppleMusicPermission()
        configureAudio()
        setupRemoteTransportControls()
        setupNowPlayingInfo()
        // Do any additional setup after loading the view.
        
    }
    // MARK: IBActions
    @IBAction func AVAudioButtonPressed(_ sender: UIButton) {
        // Look in control center. This is what I want it to look like
        playAVAudio()
    }
    @IBAction func MPMusicPlayerButtonPressed(_ sender: UIButton) {
        // My nowPlayingInfo is ignored!
        playAppleMusic()
    }
    
    func playAVAudio() {
        
        let path = Bundle.main.path(forResource: "example.m4a", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
        }
    }
    
    func configureAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.stopCommand.addTarget { [unowned self] event in
            self.audioPlayer?.stop()
            return .success
        }
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.audioPlayer?.play()
            return .success
        }
        
    }
    
    func setupNowPlayingInfo() {
        // This is what I want to appear in control center
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "My Custom Title"

        if let image = UIImage(named: "lockscreen") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    // MARK: Apple Music Player
    
    func playAppleMusic() {
        // Set queue to "Follow God" by Kanye West
        appleMusicPlayer.setQueue(with: ["1484937103"])
        appleMusicPlayer.prepareToPlay { error in
            if error != nil {
                return
            }
            self.appleMusicPlayer.play()
            self.setupNowPlayingInfo() // FIXME: Now playing info ignored!
        }
    }
    
    func requestAppleMusicPermission() {
        SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
            if status == .authorized {
                
            } else {
                
            }
            
        }
    }

}
