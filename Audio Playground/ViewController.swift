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

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    let appleMusicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAppleMusicPermission()
        configureAudio()
        setupRemoteTransportControls()
        setupNowPlaying()
        // Do any additional setup after loading the view.
        
    }
    // MARK: IBActions
    @IBAction func playButtonPressed(_ sender: UIButton) {
        playAudio()
    }
    @IBAction func playAppleMusicButtonPressed(_ sender: UIButton) {
        playAppleMusic()
    }
    
    func playAudio() {
        
        let path = Bundle.main.path(forResource: "example.m4a", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            // Couldn't load file :(
        }
    }
    
    func configureAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
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
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "My Memo"

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
