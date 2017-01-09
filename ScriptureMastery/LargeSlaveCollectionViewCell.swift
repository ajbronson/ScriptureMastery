//
//  LargeSlaveCollectionViewCell.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/17/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class LargeSlaveCollectionViewCell: UIViewController, UIWebViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var largeWebView: UIWebView!
    @IBOutlet weak var largeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Properties
    
    var book: Book?
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        largeView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor(colorLiteralRed: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 0.7)
        
        if let book = book {
            largeWebView.loadHTMLString(book.text, baseURL: nil)
            titleLabel.text = book.reference
        }
    }
    
    //MARK: - Helper Methods
    
    func updateWith(book: Book) {
        self.book = book
    }
    
    //MARK: - Webview Delegate Methods
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        largeWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
    }
    
    //MARK: - Actions
    
    @IBAction func userTappedScreen(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
