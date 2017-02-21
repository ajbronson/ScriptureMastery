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
    @IBOutlet weak var articlesOfFaithImage: UIImageView!
    @IBOutlet weak var classicPoetryImage: UIImageView!
    
    //MARK: - Properties
    
    var currentTopStarColor = Star.Color.Blue
    var currentBottomStarColor = Star.Color.Green
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        let value = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        fontStepper.minimumValue = 80
        fontStepper.maximumValue = 200
        fontStepper.stepValue = 10.0
        fontStepper.value = Double(value)
        fontTextField.text = "\(value)"
        articlesOfFaithImage.layer.cornerRadius = 10
        articlesOfFaithImage.clipsToBounds = true
        classicPoetryImage.layer.cornerRadius = 10
        classicPoetryImage.clipsToBounds = true
        updateWebView()
    }
    
    //MARK: - Helper Functions
    
    func updateWebView() {
        fontWebView.loadHTMLString("Example Font Size", baseURL: nil)
    }
    
    //MARK: - Webview Delegate Method
    
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
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            Flurry.logEvent("Email Button Tapped", withParameters: ["Unique ID" : id])
        } else {
            Flurry.logEvent("Email Button Tapped", withParameters: ["Unique ID" : "Unknown"])
        }
        
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
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            Flurry.logEvent("Font Changed", withParameters: ["Unique ID" : id, "Value" : sender.value])
        } else {
            Flurry.logEvent("Font Changed", withParameters: ["Unique ID" : "Unknown", "Value" : sender.value])
        }
        
        UserDefaults.standard.set(Int(sender.value), forKey: ScriptureController.Constant.fontSize)
        fontTextField.text = "\(Int(sender.value))"
        updateWebView()
    }
    
    @IBAction func poetryTapped(_ sender: UITapGestureRecognizer) {
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            Flurry.logEvent("View Poetry In App Store", withParameters: ["Unique ID" : id])
        } else {
            Flurry.logEvent("View Poetry In App Store", withParameters: ["Unique ID" : "Unknown"])
        }
        
        if let url = URL(string: "https://itunes.apple.com/us/app/classic-poetry-memorization/id523470453?mt=8") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func articleOfFaithTapped(_ sender: UITapGestureRecognizer) {
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            Flurry.logEvent("View Articles of Faith In App Store", withParameters: ["Unique ID" : id])
        } else {
            Flurry.logEvent("View Articles of Faith In App Store", withParameters: ["Unique ID" : "Unknown"])
        }
        
        if let url = URL(string: "https://itunes.apple.com/us/app/lds-memory-articles-faith/id396356844?mt=8") {
            UIApplication.shared.openURL(url)
        }
    }
}
