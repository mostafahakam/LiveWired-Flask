//
//  TranscriptViewController.swift
//  LiveWired
//
//  Created by Matt Goguen on 10/22/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class TranscriptViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
        
        // Test file -- Writing to a file and storing it in the file manager
        let fileName = "Test"
        let DocumentDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                          appropriateFor: nil, create: true)
        let fileURL = DocumentDirUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        let writeString = "This would display the contents of a transcribed audio file!"
        do {
            // Write to the file
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed to write to URL")
            print(error)
        }
        
        // Read from test file
        var readString = ""
        do {
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed to read file")
            print(error)
        }
        
        print("Contents of file: \(readString)")
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.lightGray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.white
    }
    
    // Ensure keyboard goes away when not editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.textView.resignFirstResponder()
    }
    
    
    
}
