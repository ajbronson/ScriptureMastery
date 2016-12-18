//
//  HelpTableViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/18/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class HelpTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var starButton: UIButton!
    
    //MARK: - Properties
    
    var currentColor = Star.Color.Blue
    
    //MARK: - Actions
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        if currentColor == Star.Color.Green {
            starButton.setImage(UIImage(named:"BlueStar"), for: .normal)
            currentColor = .Blue
        } else if currentColor == Star.Color.Blue {
            starButton.setImage(UIImage(named:"YellowStar"), for: .normal)
            currentColor = .Yellow
        } else if currentColor == Star.Color.Yellow {
            starButton.setImage(UIImage(named:"WhiteStar"), for: .normal)
            currentColor = .White
        } else if currentColor == Star.Color.White {
            starButton.setImage(UIImage(named:"GreenStar"), for: .normal)
            currentColor = .Green
        }
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "mailto://ldsmemory.scripturemasteryapp@gmail.com") {
            //UIApplication.shared.open(url)
            UIApplication.shared.openURL(url)
        }
    }
}
