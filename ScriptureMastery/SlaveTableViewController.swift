//
//  SlaveTableViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveTableViewController: UITableViewController, ChangeStar {
    
    var showHints = false
    var books: [Book]?
    var isInStarMode = false
    var starColor: Star.Color?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbar.isHidden = false
        if books?.count == 0 {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let books = books else { return UITableViewCell() }
        
        if showHints {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "slaveCell") as? SlaveTableViewCell {
                cell.updateWith(book: books[indexPath.row], isInStarMode: isInStarMode)
                cell.delegate = self
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "slaveCellNoHint") as? SlaveTableViewCellNoHint {
                cell.updateWith(book: books[indexPath.row], isInStarMode: isInStarMode)
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }

    func updateSlave(volume: Volume) {
        self.title = volume.name
        self.books = ScriptureController.shared.book(volumeID: volume.id)
        isInStarMode = false
    }
    
    func updateSlaveFromStar(books: [Book], title: String, starColor: Star.Color) {
        self.books = books
        self.title = title
        isInStarMode = true
        self.starColor = starColor
    }
    
    func shouldChangeStar(sender: UITableViewCell, starMode: Bool) {
        if let indexPath = tableView.indexPath(for: sender) {
            if starMode {
                books?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if books?.count == 0 {
                    DispatchQueue.global().async {
                        sleep(1)
                        DispatchQueue.main.async {
                             _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            } else {
                tableView.reloadRows(at: [indexPath], with: .right)
            }
        }
    }
    
    func reloadTableView(book: Book, shouldRemove: Bool) {
        if let index = books?.index(of:book),
            shouldRemove {
            self.books?.remove(at: index)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTabBar" {
            if let tabController = segue.destination as? TextTabBar,
                let indexPath = tableView.indexPathForSelectedRow,
                let books = books {
                tabController.updateWith(book: books[indexPath.row], view: self, originalStar: starColor, isInStarMode: isInStarMode)
            }
        } else if segue.identifier == "toCollectionView" {
            if let collectionVC = segue.destination as? SlaveCollectionViewController,
                let books = books {
                collectionVC.updateWith(books: books, title: self.title)
            }
        }
    }
    
    @IBAction func hintButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = showHints ? "Show Hints" : "Hide Hints"
        showHints = !showHints
        tableView.reloadData()
    }
}

protocol ChangeStar {
    func shouldChangeStar(sender: UITableViewCell, starMode: Bool)
}
