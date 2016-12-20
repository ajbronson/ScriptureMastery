//
//  LargeSlaveCollectionViewCell.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/17/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class LargeSlaveCollectionViewCell: UIViewController {
    
    @IBOutlet weak var largeWebView: UIWebView!
    @IBOutlet weak var largeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var book: Book?
    
    override func viewDidLoad() {
        //TODO: write these supers everywhere
        super.viewDidLoad()
        largeView.layer.cornerRadius = 5
        if let book = book {
            largeWebView.loadHTMLString(book.text, baseURL: nil)
            titleLabel.text = book.reference
        }
        
        self.view.backgroundColor = UIColor(colorLiteralRed: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 0.7)  
    }
    
    func updateWith(book: Book) {
        self.book = book
    }
    
    @IBAction func userTappedScreen(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
