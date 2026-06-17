//
//  SoundManager.swift
//  ChallengeSwift
//
//  Created by Vibe Code on 2024.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var clickPlayer: AVAudioPlayer?
    private var beepLowPlayer: AVAudioPlayer?
    private var beepHighPlayer: AVAudioPlayer?
    
    private init() {
        // Initialisierung der Audio-Player
        setupAudioPlayers()
    }
    
    private func setupAudioPlayers() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
        
        // Lade die Sound-Dateien
        if let clickURL = Bundle.main.url(forResource: "Default", withExtension: "wav") {
            do {
                clickPlayer = try AVAudioPlayer(contentsOf: clickURL)
                clickPlayer?.prepareToPlay()
            } catch {
                print("Error loading click sound: \(error)")
            }
        }
        
        if let beepLowURL = Bundle.main.url(forResource: "Beep-Low", withExtension: "wav") {
            do {
                beepLowPlayer = try AVAudioPlayer(contentsOf: beepLowURL)
                beepLowPlayer?.prepareToPlay()
            } catch {
                print("Error loading beep low sound: \(error)")
            }
        }
        
        if let beepHighURL = Bundle.main.url(forResource: "Beep-High", withExtension: "wav") {
            do {
                beepHighPlayer = try AVAudioPlayer(contentsOf: beepHighURL)
                beepHighPlayer?.prepareToPlay()
            } catch {
                print("Error loading beep high sound: \(error)")
            }
        }
    }
    
    func playClick() {
        clickPlayer?.currentTime = 0
        clickPlayer?.play()
    }
    
    func playBeepLow() {
        beepLowPlayer?.currentTime = 0
        beepLowPlayer?.play()
    }
    
    func playBeepHigh() {
        beepHighPlayer?.currentTime = 0
        beepHighPlayer?.play()
    }
    
    func dispose() {
        clickPlayer = nil
        beepLowPlayer = nil
        beepHighPlayer = nil
    }
}
