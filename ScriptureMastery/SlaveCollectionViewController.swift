//
//  SlaveCollectionViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/17/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var books: [Book]?
    var showHints = false
    var isInStarMode = false
    var showHeader = false
    var starCanonIDs:[Int] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateWith(books: [Book], title: String?, starMode: Bool, showHeader: Bool) {
        self.books = books
        self.title = title
        self.isInStarMode = starMode
        self.showHeader = showHeader
        if isInStarMode || showHeader {
            organizeBooks()
        }
    }
    
    func organizeBooks() {
        guard let books = books else { return }
        let sortedBooks = books.sorted{$0.canonID < $1.canonID}
        self.books = sortedBooks
        starCanonIDs = sortedBooks.flatMap({$0.canonID})
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isInStarMode || showHeader  {
            var count = 0
            let singleCanonIDs = (Array(Set(starCanonIDs)))
            let sortedIDs = singleCanonIDs.sorted{$0 < $1}
            
            for item in starCanonIDs {
                if item == sortedIDs[section] {
                    count += 1
                }
            }
            
            return count
        } else {
            return books?.count ?? 0
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isInStarMode || showHeader  {
            return Array(Set(starCanonIDs)).count
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? SlaveCollectionHeaderView else { return UICollectionReusableView() }
        if isInStarMode || showHeader  {
            let singleCanonIDs = (Array(Set(starCanonIDs)))
            let sortedIDs = singleCanonIDs.sorted{$0 < $1}
            headerView.updateHeader(title: ScriptureController.shared.volumeNameForID(id: sortedIDs[indexPath.section]))
            headerView.backgroundColor = UIColor(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            return headerView
            
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isInStarMode || showHeader  {
            return CGSize(width: 25, height: 25)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? SlaveCollectionViewCell,
            let books = books else { return UICollectionViewCell() }
        
        if isInStarMode || showHeader  {
            let singleCanonIDs = (Array(Set(starCanonIDs)))
            let sortedIDs = singleCanonIDs.sorted{$0 < $1}
            let filteredBooks = books.filter({$0.canonID == sortedIDs[indexPath.section]})
            cell.updateWith(book: filteredBooks[indexPath.row], showHints: showHints)
        } else {
            cell.updateWith(book: books[indexPath.row], showHints: showHints)
        }
        cell.layer.shadowColor = UIColor(colorLiteralRed: 86.0/255.0, green: 128.0/255.0, blue: 91.0/255.0, alpha: 1.0).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 8
        cell.layer.shadowOpacity = 0.8
        cell.layer.masksToBounds = false
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SlaveCollectionViewCell{
            UIView.transition(with: cell.customView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func showHintButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = showHints ? "Show Hints" : "Hide Hints"
        showHints = !showHints
        collectionView?.reloadData()
        
    }
    
    @IBAction func toListModeButtonTapped(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLargeCell" {
            if let destinationVC = segue.destination as? LargeSlaveCollectionViewCell,
                let index = collectionView?.indexPathsForSelectedItems,
                let indexPath = index.first,
                let books = books {
                if isInStarMode || showHeader {
                    let singleCanonIDs = (Array(Set(starCanonIDs)))
                    let sortedIDs = singleCanonIDs.sorted{$0 < $1}
                    let filteredBooks = books.filter({$0.canonID == sortedIDs[indexPath.section]})
                    destinationVC.updateWith(book: filteredBooks[indexPath.row])
                } else {
                    destinationVC.updateWith(book: books[indexPath.row])
                }
            }
        }
    }
}
