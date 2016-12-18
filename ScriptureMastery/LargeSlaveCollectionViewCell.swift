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
    
    override func viewDidAppear(_ animated: Bool) {
        largeWebView.loadHTMLString("Hello", baseURL: nil)
    }
    
    override func viewDidLoad() {
        //TODO: write these supers everywhere
        super.viewDidLoad()
        print("test")
    }
}
