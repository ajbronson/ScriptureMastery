//
//  TextTabBar.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/16/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class TextTabBar: UITabBarController {
    
    //MARK: - Properties
    
    var book: Book?
    var books: [Book]?
    var slaveTableViewController: SlaveTableViewController?
    var originalStar: Star.Color?
    var starMode = false
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.tabBar.tintColor = UIColor(colorLiteralRed: 13/255.0, green: 61/255.0, blue: 159/255.0, alpha: 1.0)
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
    
    //MARK: - Helper Methods
    
    func updateWith(book: Book, books: [Book], view: SlaveTableViewController, originalStar: Star.Color?, isInStarMode: Bool) {
        self.book = book
        self.books = books
        setImageBarButton()
        self.slaveTableViewController = view
        self.originalStar = originalStar
        self.starMode = isInStarMode
    }
    
    func starUpdated() {
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            Flurry.logEvent("Star Clicked", withParameters: ["Unique ID" : id])
        } else {
            Flurry.logEvent("Star Clicked", withParameters: ["Unique ID" : "Unknown"])
        }
        
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
    
    func switchToBook(next: Bool) -> Bool {
        guard let book = book,
            let books = books,
            let viewControllers = viewControllers,
            let index = books.index(of: book) else { return false }
        
        var bookChanged = false
        
        if next && Int(index) < (books.count - 1) {
            self.book = books[index + 1]
            bookChanged = true
        } else if !next && Int(index) > 0 {
            self.book = books[index - 1]
            bookChanged = true
        }
        
        if bookChanged {
            for viewController in viewControllers {
                if let vc = viewController as? FullTextViewController {
                    vc.book = self.book
                    
                    if vc.isViewLoaded {
                        vc.bookDidChange()
                    }
                } else if let vc = viewController as? SectionViewController {
                    vc.book = self.book
                    
                    if vc.isViewLoaded {
                        vc.bookDidChange()
                    }
                } else if let vc = viewController as? FirstLetterViewController {
                    vc.book = self.book
                    
                    if vc.isViewLoaded {
                        vc.bookDidChange()
                    }
                } else if let vc = viewController as? RandomWordViewController {
                    vc.book = self.book
                    
                    if vc.isViewLoaded {
                        vc.bookDidChange()
                    }
                }
            }
        }
        
        return bookChanged
    }
}
