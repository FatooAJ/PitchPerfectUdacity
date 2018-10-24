//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Fatima ALjaber on 10/23/18.
//  Copyright © 2018 Fatima ALjaber. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var RecordLabel: UILabel!
    @IBOutlet weak var StopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopRecordingButton.isEnabled = false
    }

    @IBAction func RecordButton(_ sender: UIButton) {
        StopRecordingButton.isEnabled = true
        RecordingButton.isEnabled = false
        RecordLabel.text = "Recording in progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
        
    
    @IBAction func StopRecordingButton(_ sender: UIButton) {
        StopRecordingButton.isEnabled = false
        RecordingButton.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "StopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StopRecording"{
            let PlaySoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            PlaySoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

