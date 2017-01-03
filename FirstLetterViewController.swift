//
//  FirstLetterViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class FirstLetterViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var wordWebView: UIWebView!
    @IBOutlet weak var letterTextField: UITextField!
    @IBOutlet weak var letterSlider: UISlider!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    //MARK: - Properties
    
    var firstLetterText: String = ""
    var currentText: [String] = ["", ""]
    var indexesRemoved:[Int] = []
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterSlider.maximumValue = 25
        letterSlider.minimumValue = 1
        letterSlider.setValue(5.0, animated: false)
        letterTextField.text = "5"
        removeButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        
        if let parentVC = parent as? TextTabBar,
            let book = parentVC.book {
            self.tabBarController?.title = book.reference
            firstLetterText = book.text.setFirstLetters()

            for _ in 0...3 {
                let index = firstLetterText.index(firstLetterText.startIndex, offsetBy: 1)
                let removeIndex = firstLetterText.index(firstLetterText.startIndex, offsetBy: 0)
                let letter =  firstLetterText.substring(to: index)
                if letter.isNumeric() || letter == " " {
                    firstLetterText.remove(at: removeIndex)
                }
            }
            currentText = firstLetterText.getStringArray()
            reloadHTML()
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
        let count = Int(letterSlider.value)
        
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
    
    @IBAction func letterSliderDidChange(_ sender: UISlider) {
        let value: Int = Int(letterSlider.value)
        letterTextField.text = "\(value)"
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        indexesRemoved = []
        currentText = firstLetterText.getStringArray()
        reloadHTML()
    }

    @IBAction func removeButtonTapped(_ sender: UIButton) {
        removeElements()
        reloadHTML()
    }
}
