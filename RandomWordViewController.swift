//
//  RandomWordViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class RandomWordViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordSlider: UISlider!
    @IBOutlet weak var wordWebView: UIWebView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    //MARK: - Properties
    
    var bookText: String = ""
    var currentText: [String] = ["", ""]
    var indexesRemoved:[Int] = []
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordSlider.maximumValue = 25
        wordSlider.minimumValue = 1
        wordSlider.setValue(5.0, animated: false)
        wordTextField.text = "5"
        removeButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        currentText = bookText.getStringArray()
        
        if let parentVC = parent as? TextTabBar {
            if let book = parentVC.book {
                self.tabBarController?.title = book.reference
                bookText = book.text
                currentText = bookText.getStringArray()
                reloadHTML()
            }
        }
    }
    
    //MARK: - Webview Delegate Methods
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        wordWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
    }
    
    //MARK: - Helper Methods
    
    func reloadHTML() {
        wordWebView.loadHTMLString(currentText.joined(separator: " "), baseURL: nil)
    }
    
    func removeElements() {
        let count = Int(wordSlider.value)
        
        for _ in 0..<count {
            
            if currentText.count == indexesRemoved.count {
                return
            }
            
            var random = Int(arc4random_uniform(UInt32(currentText.count)))
            
            while (indexesRemoved.contains(random)) {
                random = Int(arc4random_uniform(UInt32(currentText.count)))
            }
            
            currentText[random] = "__"
            indexesRemoved.append(random)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        let value: Int = Int(wordSlider.value)
        wordTextField.text = "\(value)"
    }
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        removeElements()
        reloadHTML()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        indexesRemoved = []
        currentText = bookText.getStringArray()
        reloadHTML()
    }
}
