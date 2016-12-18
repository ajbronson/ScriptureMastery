//
//  TextTabBar.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/16/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class TextTabBar: UITabBarController {
    var book: Book?
    var slaveTableViewController: SlaveTableViewController?
    var originalStar: Star.Color?
    var starMode = false
    
    func updateWith(book: Book, view: SlaveTableViewController, originalStar: Star.Color?, isInStarMode: Bool) {
        self.book = book
        setImageBarButton()
        self.slaveTableViewController = view
        self.originalStar = originalStar
        self.starMode = isInStarMode
    }
    
    func starUpdated() {
        if let book = book {
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
            setImageBarButton()
        }
    }
    
    private func setImageBarButton() {
        if let book = book {
            if let blue = book.blueStar, blue {
                let rightBarItem = UIBarButtonItem(image: UIImage(named:"BlueStar")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(starUpdated))
                self.navigationItem.rightBarButtonItem = rightBarItem
            } else if let green = book.greenStar, green {
                let rightBarItem = UIBarButtonItem(image: UIImage(named:"GreenStar")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(starUpdated))
                self.navigationItem.rightBarButtonItem = rightBarItem
            } else if let yellow = book.yellowStar, yellow {
                let rightBarItem = UIBarButtonItem(image: UIImage(named:"YellowStar")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(starUpdated))
                self.navigationItem.rightBarButtonItem = rightBarItem
            } else {
                let rightBarItem = UIBarButtonItem(image: UIImage(named:"WhiteStar")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(starUpdated))
                self.navigationItem.rightBarButtonItem = rightBarItem
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let book = book {
            var currenStar: Star.Color = Star.Color.White
            if let blue = book.blueStar, blue {
                currenStar = Star.Color.Blue
            } else if let yellow = book.yellowStar, yellow {
                currenStar = Star.Color.Yellow
            } else if let green = book.greenStar, green {
                currenStar = Star.Color.Green
            }
            slaveTableViewController?.reloadTableView(book: book, shouldRemove: starMode == true ? originalStar?.rawValue != currenStar.rawValue : false)
        }
    }
}
