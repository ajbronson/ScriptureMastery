//
//  HelpTableViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/18/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class HelpTableViewController: UITableViewController, UIWebViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var secondStarButton: UIButton!
    @IBOutlet weak var fontWebView: UIWebView!
    @IBOutlet weak var fontTextField: UITextField!
    @IBOutlet weak var fontStepper: UIStepper!
    
    //MARK: - Properties
    
    var currentTopStarColor = Star.Color.Blue
    var currentBottomStarColor = Star.Color.Green
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        let value = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        fontStepper.minimumValue = 50
        fontStepper.maximumValue = 300
        fontStepper.stepValue = 10.0
        fontStepper.value = Double(value)
        fontTextField.text = "\(value)"
        updateWebView()
    }
    
    //MARK: - Helper Functions
    
    func updateWebView() {
        fontWebView.loadHTMLString("Example Font Size", baseURL: nil)
    }
    
    //MARK: - Webview Delegate Methods
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        fontWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
    }
    
    //MARK: - Actions
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        if currentTopStarColor == Star.Color.Green {
            starButton.setImage(UIImage(named:"BlueStar"), for: .normal)
            currentTopStarColor = .Blue
        } else if currentTopStarColor == Star.Color.Blue {
            starButton.setImage(UIImage(named:"YellowStar"), for: .normal)
            currentTopStarColor = .Yellow
        } else if currentTopStarColor == Star.Color.Yellow {
            starButton.setImage(UIImage(named:"WhiteStar"), for: .normal)
            currentTopStarColor = .White
        } else if currentTopStarColor == Star.Color.White {
            starButton.setImage(UIImage(named:"GreenStar"), for: .normal)
            currentTopStarColor = .Green
        }
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "mailto://ldsmemory.scripturemasteryapp@gmail.com") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func secondStarButtonTapped(_ sender: UIButton) {
        if currentBottomStarColor == Star.Color.Green {
            secondStarButton.setImage(UIImage(named:"WhiteStar"), for: .normal)
            currentBottomStarColor = .White
        } else if currentBottomStarColor == Star.Color.White {
            secondStarButton.setImage(UIImage(named:"GreenStar"), for: .normal)
            currentBottomStarColor = .Green
        }
    }
    
    @IBAction func fontStepperTapped(_ sender: UIStepper) {
        UserDefaults.standard.set(Int(sender.value), forKey: ScriptureController.Constant.fontSize)
        fontTextField.text = "\(Int(sender.value))"
        updateWebView()
    }
}
