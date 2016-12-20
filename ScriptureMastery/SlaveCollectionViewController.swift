//
//  SlaveCollectionViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/17/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveCollectionViewController: UICollectionViewController {
    
    var books: [Book]?
    var showHints = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true;
    }
    
    func updateWith(books: [Book], title: String?) {
        self.books = books
        self.title = title
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? SlaveCollectionViewCell,
            let books = books else { return UICollectionViewCell() }
        cell.updateWith(book: books[indexPath.row], showHints: showHints)
        cell.layer.shadowColor = UIColor.black.cgColor
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
    
    @IBAction func showHintButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = showHints ? "Show Hints" : "Hide Hints"
        showHints = !showHints
        collectionView?.reloadData()
        
    }
    @IBAction func toListModeButtonTapped(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLargeCell" {
            if let destinationVC = segue.destination as? LargeSlaveCollectionViewCell,
                let index = collectionView?.indexPathsForSelectedItems,
                let indexPath = index.first,
                let books = books {
                destinationVC.updateWith(book: books[indexPath.row])
            }
        }
    }
}
