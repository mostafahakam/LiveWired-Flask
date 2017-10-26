//
//  DetailViewController.swift
//  LiveWired
//
//  Created by Mostafa Hakam on 2017-10-16.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import Speech

class DetailViewController: UIViewController, SFSpeechRecognizerDelegate {
    var recording = false;
    var recordingNum = 0;
    var currentRecording = "";
    
    @IBOutlet weak var SpeechToTextLabel: UILabel!
    @IBOutlet weak var StartStopButton: UIButton!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if(!recording){
            print("Starting recording")
            self.recordAndRecognizeSpeech()
        }else{
            print("Stopping recording")
            audioEngine.stop()
            recording = false;
            UserDefaults.standard.set(self.currentRecording, forKey:"sampleRecording \(recordingNum)")
            recordingNum += 1
            self.currentRecording = ""
        }
    }
    
    
    func recordAndRecognizeSpeech() {
        recording = true;

        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else { return }
        if !myRecognizer.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.SpeechToTextLabel.text = bestString
                self.currentRecording = bestString
            } else if let error = error {
                print(error)
            }
        })
    }
    
}
