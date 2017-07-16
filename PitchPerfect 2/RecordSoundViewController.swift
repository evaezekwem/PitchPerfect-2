//
//  ViewController.swift
//  PitchPerfect 2
//
//  Created by Eva on 13/07/2017.
//  Copyright © 2017 Eva. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    //MARK: Creating the variable to handle audio recording
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.isEnabled = false
        
    }
    
    //MARK: Action performed when the Record button is clicked
    @IBAction func onClick_recordButton (_ sender: UIButton) {
        
        recordingLabel.text = "Recording in Progress..."
        stopButton.isEnabled = true
        recordButton.isEnabled = false
        
        //Generates the full URL for the file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        
        //Sets up audio recording parameters
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        //Handles the actual recording of audio
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    //MARK: Action performed when the Stop button is clicked
    @IBAction func onClick_stopButton (_ sender: UIButton) {
        
        recordingLabel.text = "Tap to Record"
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        
        //Stops audio recording and ends recording session
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    //MARK: Protocol function called when audio ends. It is defined in AVAudioRecordDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "recordToPlayingSound", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recordToPlayingSound" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

