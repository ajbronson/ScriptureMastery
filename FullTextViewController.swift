//
//  FullTextViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit
import AVFoundation

class FullTextViewController: UIViewController {
    
    @IBOutlet weak var wordWebView: UIWebView!
    @IBOutlet weak var speechSlider: UISlider!
    @IBOutlet weak var speechTextField: UITextField!
    let synthesizer = AVSpeechSynthesizer()
    var rate: Double = 0.5
    var utterance: AVSpeechUtterance?
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parentVC = parent as? TextTabBar,
            let book = parentVC.book {
            self.book = book
            self.tabBarController?.title = book.reference
            wordWebView.loadHTMLString(book.text, baseURL: nil)
            tabBarController
        }
        
        speechSlider.maximumValue = 2.0
        speechSlider.minimumValue = 0.1
        speechSlider.setValue(1.0, animated: false)
        updateTextField(value: 1.0)

    }
    
    func updateTextField(value: Double) {
        speechTextField.text = "\(value)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func speechSliderValueChanged(_ sender: UISlider) {
        if speechSlider.value > 1.0 && speechSlider.value < 1.6 {
            speechSlider.setValue(1.5, animated: true)
            updateTextField(value: 1.5)
        } else if speechSlider.value > 1.5 {
            speechSlider.setValue(2.0, animated: true)
            updateTextField(value: 2.0)
        } else if speechSlider.value > 0.6 && speechSlider.value < 1.1 {
            speechSlider.setValue(1.0, animated: true)
            updateTextField(value: 1.0)
        } else if speechSlider.value < 1.0 && speechSlider.value > 0.4 {
            speechSlider.setValue(0.5, animated: true)
            updateTextField(value: 0.5)
        } else {
            speechSlider.setValue(0.1, animated: true)
            updateTextField(value: 0.1)
        }
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        utterance = AVSpeechUtterance(string: book?.text ?? "")
        if let utterance = utterance {
            if speechSlider.value == 0.1 {
                utterance.rate = 0.3
            } else if speechSlider.value == 0.5 {
                utterance.rate = 0.4
            } else if speechSlider.value == 1.0 {
                utterance.rate = 0.5
            } else if speechSlider.value == 1.5 {
                utterance.rate = 0.55
            } else {
                utterance.rate = 0.6
            }
            
            synthesizer.speak(utterance)
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
