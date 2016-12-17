//
//  FirstLetterViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class FirstLetterViewController: UIViewController {
    
    @IBOutlet weak var wordWebView: UIWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        wordWebView.loadHTMLString("Hello World", baseURL: nil)
    }
}
