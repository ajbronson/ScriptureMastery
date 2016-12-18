//
//  SectionViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/16/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {
    
    //MARK: - Properties 
    
    @IBOutlet weak var sectionWebView: UIWebView!
    @IBOutlet weak var displayingLabel: UILabel!
    var sections: [String] = []
    var displayingSections = 0
    var firstLetterOnly = false
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
