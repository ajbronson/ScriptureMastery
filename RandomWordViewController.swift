//
//  RandomWordViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class RandomWordViewController: UIViewController {
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordSlider: UISlider!
    @IBOutlet weak var wordWebView: UIWebView!
    
    override func viewDidLoad() {
        wordSlider.maximumValue = 25
        wordSlider.minimumValue = 1
        wordSlider.setValue(5.0, animated: false)
        wordTextField.text = "5"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wordWebView.loadHTMLString("Hello World", baseURL: nil)
    }
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        let value: Int = Int(wordSlider.value)
        wordTextField.text = "\(value)"
    }
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
    }
}
