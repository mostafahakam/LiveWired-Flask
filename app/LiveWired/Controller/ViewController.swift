//
//  ViewController.swift
//  LiveWired
//
//  Created by Mostafa Hakam on 2017-10-16.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate{
    
    var recording = false
    var recordingNum = 0
    var currentRecording = ""
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    let imageView: UIImageView = {
        let logo = UIImage(named: "LogoIcon")
        let imageView = UIImageView(image:logo)
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 30)
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 30)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let audioButton1: UIButton = {
        let button = UIButton()
        return button
    }()
    let audioButton2: UIButton = {
        let button = UIButton()
        return button
    }()
    let audioButton3: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let SpeechToTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        
        self.view.addSubview(audioButton1)
        setupAudioButton(diameter: 60, color: UIColor(r: 255, g: 136, b: 77), button: audioButton1)
        self.view.addSubview(audioButton2)
        setupAudioButton(diameter: 55, color: UIColor(r: 220, g: 220, b: 220), button: audioButton2)
        self.view.addSubview(audioButton3)
        setupAudioButton(diameter: 50, color: UIColor(r: 255, g: 136, b: 77), button: audioButton3)
        
        self.view.addSubview(SpeechToTextLabel)
        
        seteupSpeechToTextLabel()
        setupNavigation()
        
        handleAuthentication()
        
    }
    
    func seteupSpeechToTextLabel(){
        SpeechToTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        SpeechToTextLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        SpeechToTextLabel.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20).isActive = true
    }
    
    func setupAudioButton(diameter: CGFloat, color: UIColor, button: UIButton) {
        button.backgroundColor = color
        button.frame = CGRect(x: ((self.view.frame.size.width/2)-(diameter/2)) , y: (self.view.frame.size.height-70-(diameter/2)), width: diameter, height: diameter)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    func setupNavigation() {
        navigationItem.titleView = imageView
        navigationItem.titleView?.tintColor = UIColor.black
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func handleAuthentication() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
        }
    }
    
    @objc func handleMenu() {
        
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
    
    @IBAction func logoutHandler(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func startButtonTapped(_ sender: UIButton) {
        if !recording {
            print("Starting recording")
            self.recordAndRecognizeSpeech()
        } else {
            print("Stopping recording")
            audioEngine.stop()
            recording = false
            UserDefaults.standard.set(self.currentRecording, forKey:"sampleRecording \(recordingNum)")
            recordingNum += 1
            self.currentRecording = ""
        }
    }


    func recordAndRecognizeSpeech() {
        recording = true


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
                print(bestString)
                self.currentRecording = bestString
            } else if let error = error {
                print(error)
            }
        })
    }
}
