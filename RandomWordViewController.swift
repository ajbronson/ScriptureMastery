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
    
    var currentText: [String] = ["", ""]
    var indexesRemoved:[Int] = []
    var book: Book?
    var books: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordSlider.maximumValue = 25
        wordSlider.minimumValue = 1
        wordSlider.setValue(5.0, animated: false)
        wordTextField.text = "5"
        removeButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        
        if let parentVC = parent as? TextTabBar,
            let book = parentVC.book,
            let books = parentVC.books {
            self.tabBarController?.title = book.reference
            self.books = books
            self.book = book
            setCurrentText()
            reloadHTML()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        wordWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
    }
    
    func setCurrentText() {
        if let book = book {
            let myText = book.text.replacingOccurrences(of: "\n", with: "<br>")
            let stringArray = myText.getStringArray()
            currentText = []
            for string in stringArray {
                let array = string.components(separatedBy: "<br>")
                for i in 0..<(array.count) {
                    if array[i] == "" {
                        currentText.append("<br>")
                    } else {
                        if i == (array.count - 1) {
                            currentText.append(array[i])
                        } else {
                            currentText.append(array[i])
                            currentText.append("<br>")
                        }
                    }
                }
            }
        }
    }
    
    func reloadHTML() {
        let bookText = currentText.joined(separator: " ")
        wordWebView.loadHTMLString(bookText, baseURL: nil)
    }
    
    func removeElements(count: Int) {
        for _ in 0..<count {
            
            if currentText.count == indexesRemoved.count {
                return
            }
            
            var random = Int(arc4random_uniform(UInt32(currentText.count)))
            
            while (indexesRemoved.contains(random)) {
                random = Int(arc4random_uniform(UInt32(currentText.count)))
            }
            
            indexesRemoved.append(random)
            if currentText[random] == "<br>" {
                removeElements(count: 1)
            } else {
                currentText[random] = "__"
            }
        }
    }
    
    func bookDidChange() {
        if let book = book {
            self.tabBarController?.title = book.reference
            setCurrentText()
            reloadHTML()
        }
    }
    //MARK: - Actions
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        let value: Int = Int(wordSlider.value)
        wordTextField.text = "\(value)"
    }
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        removeElements(count: Int(wordSlider.value))
        reloadHTML()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        indexesRemoved = []
        setCurrentText()
        reloadHTML()
    }
    
    @IBAction func screenSwipedRight(_ sender: UISwipeGestureRecognizer) {
        if let parentVC = parent as? TextTabBar {
            if parentVC.switchToBook(next: false) {
                bookDidChange()
                indexesRemoved = []
            }
        }
    }
    
    @IBAction func screenSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        if let parentVC = parent as? TextTabBar {
            if parentVC.switchToBook(next: true) {
                bookDidChange()
                indexesRemoved = []
            }
        }
    }
}
