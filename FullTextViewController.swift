//
//  FullTextViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit
import AVFoundation

class FullTextViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var wordWebView: UIWebView!
    @IBOutlet weak var speechSlider: UISlider!
    @IBOutlet weak var speechTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //MARK: - Properties
    
    let synthesizer = AVSpeechSynthesizer()
    var rate: Double = 0.5
    var utterance: AVSpeechUtterance?
    
    var book: Book?
    var books: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        playButton.layer.cornerRadius = 5
        stopButton.layer.cornerRadius = 5
        if let parentVC = parent as? TextTabBar,
            let book = parentVC.book,
            let books = parentVC.books {
            self.book = book
            self.books = books
            self.tabBarController?.title = book.reference
            let bookText = book.text.replacingOccurrences(of: "\n", with: "<br>")
            wordWebView.loadHTMLString(bookText, baseURL: nil)
        }
        
        speechSlider.maximumValue = 2.0
        speechSlider.minimumValue = 0.1
        speechSlider.setValue(1.0, animated: false)
        updateTextField(value: 1.0)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        wordWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
    }
    
    func updateTextField(value: Double) {
        speechTextField.text = "\(value)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    //MARK: - Actions
    
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
        playButton.setTitle("Play", for: .normal)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            playButton.setTitle("Pause", for: .normal)
        } else if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
            playButton.setTitle("Play", for: .normal)
        } else {
            utterance = AVSpeechUtterance(string: book?.text ?? "")
            playButton.setTitle("Pause", for: .normal)
            
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
    }
    
    func bookDidChange() {
        if let book = book {
            self.tabBarController?.title = book.reference
            let bookText = book.text.replacingOccurrences(of: "\n", with: "<br>")
            wordWebView.loadHTMLString(bookText, baseURL: nil)
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        playButton.setTitle("Play", for: .normal)
    }
    
    @IBAction func screenSwipedRight(_ sender: UISwipeGestureRecognizer) {
        if let parentVC = parent as? TextTabBar {
            if parentVC.switchToBook(next: false) {
                bookDidChange()
                synthesizer.stopSpeaking(at: .immediate)
                playButton.setTitle("Play", for: .normal)
            }
        }
    }
    
    @IBAction func screenSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        if let parentVC = parent as? TextTabBar {
            if parentVC.switchToBook(next: true) {
                bookDidChange()
                synthesizer.stopSpeaking(at: .immediate)
                playButton.setTitle("Play", for: .normal)
            }
        }
    }
}
