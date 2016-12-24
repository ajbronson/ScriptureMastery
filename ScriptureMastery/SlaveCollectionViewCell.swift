//
//  SlaveCollectionViewCell.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/17/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    
    //MARK: - Properties
    
    var faceUp = true
    
    //MARK: - Helper Methods
    
    func updateWith(book: Book, showHints: Bool) {
        if faceUp {
            titleLabel.text = book.reference
            subtitleLabel.text = showHints ? book.hint : ""
            customView.layer.cornerRadius = 5
        } else {
            titleLabel.text = book.text
        }
    }
}
