//
//  SlaveTableViewCell.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/17/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    //MARK: - Properties
    
    var delegate: ChangeStar?
    var book: Book?
    var isInStarMode = false
    
    //MARK: - Helper Methods
    
    func updateWith(book: Book, isInStarMode: Bool) {
        titleLabel.text = book.reference
        subtitleLabel.text = book.hint
        self.book = book
        self.isInStarMode = isInStarMode
        
        if let blue = book.blueStar, blue {
            starButton.setImage(UIImage(named: "BlueStar"), for: .normal)
        } else if let green = book.greenStar, green {
            starButton.setImage(UIImage(named: "GreenStar"), for: .normal)
        } else if let yellow = book.yellowStar, yellow {
            starButton.setImage(UIImage(named: "YellowStar"), for: .normal)
        } else {
            starButton.setImage(UIImage(named: "WhiteStar"), for: .normal)
        }
        
        let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize)/6.2)
        subtitleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize)/10)
    }
    
    //MARK: - Actions
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            Flurry.logEvent("Star Clicked", withParameters: ["Unique ID" : id])
        } else {
            Flurry.logEvent("Star Clicked", withParameters: ["Unique ID" : "Unknown"])
        }
        
        if let book = book {
            if isInStarMode {
                ScriptureController.shared.updateBookStar(book: book, hasYellowStar: 0, hasBlueStar: 0, hasGreenStar: 0)
                book.blueStar = false
                book.greenStar = false
                book.yellowStar = false
            } else {
                if let green = book.greenStar, green {
                    ScriptureController.shared.updateBookStar(book: book, hasYellowStar: 0, hasBlueStar: 1, hasGreenStar: 0)
                    book.blueStar = true
                    book.greenStar = false
                } else if let blue = book.blueStar, blue {
                    ScriptureController.shared.updateBookStar(book: book, hasYellowStar: 1, hasBlueStar: 0, hasGreenStar: 0)
                    book.yellowStar = true
                    book.blueStar = false
                } else if let yellow = book.yellowStar, yellow {
                    ScriptureController.shared.updateBookStar(book: book, hasYellowStar: 0, hasBlueStar: 0, hasGreenStar: 0)
                    book.yellowStar = false
                } else {
                    ScriptureController.shared.updateBookStar(book: book, hasYellowStar: 0, hasBlueStar: 0, hasGreenStar: 1)
                    book.greenStar = true
                }
            }
        }
        
        delegate?.shouldChangeStar(sender: self, starMode: isInStarMode)
    }
}
