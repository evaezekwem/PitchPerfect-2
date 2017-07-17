//
//  PlaySoundViewController.swift
//  PitchPerfect 2
//
//  Created by Eva on 15/07/2017.
//  Copyright © 2017 Eva. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var soundDurationLabel: UILabel!
    @IBOutlet weak var soundSlider: UISlider!
    
    //The current time of the sound file presently associated with the audio player
    //var currentTime: TimeInterval { get set }
    
    //The duration of the sound file associated with the audio player
    //var duration: TimeInterval { get }
    
    //var audio: AVAudioPlayer
    
    
    //MARK: Declares parameter for audio playback
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var audioPlayer: AVAudioPlayer!
    
    enum ButtonType: Int {case slow = 0, fast, chipmunk, vader, echo, reverb }
    
    @IBAction func playSoundForButton(_ sender: UIButton){
        
        //audioPlayer doesn't actually play the sound rather is used to update player time.
        audioPlayer.prepareToPlay()
        
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
            
        case .fast:
            playSound(rate: 1.5)
            
        case .chipmunk:
            playSound(pitch: 1000)
            
        case .vader:
            playSound(pitch: -1000)
            
        case .echo:
            playSound(echo: true)
            
        case .reverb:
            playSound(reverb: true)
            
        }
        configureUI(.playing)
        audioPlayer.play()
        
        
        
        
        
    }
    
    @IBAction func stopButtonPressed (_ sender: AnyObject){
        stopAudio()
        audioPlayer.stop()
        soundSlider.setValue(0.0, animated: true)
        
    }
    
    @IBAction func ChangeAudioTime(){
        /*
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(soundSlider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        */
        
        
        let currentTime: AVAudioTime
       
        
        audioPlayerNode.pause()
        currentTime = AVAudioTime(hostTime: UInt64(Float(soundSlider.value))) //maps slider value to AVAudioTime type
        audioPlayerNode.play(at: currentTime)
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        
        //audioPlayer doesn't actually play the sound rather is used to update player time.
        //audioPlayNode combines all the various nodes (snail, chipmunk, vader etc) and plays the actual sound
        audioPlayer = try! AVAudioPlayer(contentsOf: recordedAudioURL)
        audioPlayer.volume = 0.0
        
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PlaySoundViewController.updateSlider), userInfo: nil, repeats: true)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
        
        soundSlider.maximumValue = Float(TimeInterval(audioPlayer.duration))
        
        soundDurationLabel.text = stringFromTimeInterval(interval: audioPlayer.duration)
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let time = Int(interval)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }

    func updateSlider() {
        
        soundSlider.value = Float(audioPlayer.currentTime)
        NSLog("SliderUpdate")
    }

}
