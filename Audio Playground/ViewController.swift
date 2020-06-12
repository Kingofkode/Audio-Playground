//
//  ViewController.swift
//  Audio Playground
//
//  Created by Isaiah Suarez on 6/12/20.
//  Copyright © 2020 Isaiah Suarez. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAudio()
        // Do any additional setup after loading the view.
        
    }
    // MARK: IBActions
    @IBAction func playButtonPressed(_ sender: UIButton) {
        playAudio()
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
    

}
