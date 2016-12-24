//
//  SectionViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/16/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: - Properties 
    
    @IBOutlet weak var sectionWebView: UIWebView!
    @IBOutlet weak var displayingLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var sections: [String] = []
    var displayingSections = 1
    var firstLetterOnly = false
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeButton.layer.cornerRadius = 5
        addButton.layer.cornerRadius = 5
        if let parentVC = parent as? TextTabBar,
            let book = parentVC.book {
            self.tabBarController?.title = book.reference
            sections = book.text.getSections()
            reloadHTML()
            updateDisplaying()
        }
    }
    
    //MARK: - Helper Methods
    
    func reloadHTML() {
        var stringToShow = ""
        for i in 0..<displayingSections {
            if firstLetterOnly && i != displayingSections - 1 {
                stringToShow += "\(sections[i].setFirstLetters()) | "
            } else {
                stringToShow += "\(sections[i]) | "
            }
        }
        sectionWebView.loadHTMLString(stringToShow, baseURL: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        sectionWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
        
        if let heightResult = sectionWebView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;"),
            let height = Int(heightResult) {
            let script = "scrollTo(1, \(height))"
            sectionWebView.stringByEvaluatingJavaScript(from: script)
        }
    }
    
    func updateDisplaying() {
        displayingLabel.text = "Displaying Sections \(displayingSections) of \(sections.count)"
    }
    
    //MARK: - Actions
    
    @IBAction func removeSectionButtonTapped(_ sender: UIButton) {
        if displayingSections > 0 {
            displayingSections -= 1
            reloadHTML()
            updateDisplaying()
        }
    }
    
    @IBAction func addSectionButtonTapped(_ sender: UIButton) {
        if displayingSections < sections.count {
           displayingSections += 1
            reloadHTML()
            updateDisplaying()
        }
    }
    
    @IBAction func firstLetterToggled(_ sender: UISwitch) {
        firstLetterOnly = sender.isOn
        reloadHTML()
    }
}
