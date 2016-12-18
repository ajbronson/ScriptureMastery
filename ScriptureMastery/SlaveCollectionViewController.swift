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
        print("Selected")
        test(indexPath: indexPath)
    }
    
    @IBAction func showHintButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = showHints ? "Show Hints" : "Hide Hints"
        showHints = !showHints
        collectionView?.reloadData()
        
    }
    @IBAction func toListModeButtonTapped(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func flipCard() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LargeCollectionCell") as? LargeSlaveCollectionViewCell,
            let mainWindow = UIApplication.shared.delegate?.window {
            mainWindow?.addSubview(vc.view)
            //navigationController?.pushViewController(vc, animated: true)
        }
//        if  {
//            mainWindow?.addSubview(<#T##view: UIView##UIView#>)
//        }
    }
    
    
    func test(indexPath: IndexPath) {
        if let cell = collectionView?.cellForItem(at: indexPath) as? SlaveCollectionViewCell,
            let books = books {
            //books[indexPath.row].faceUp = !books[indexPath.row].faceUp
            
            UIView.transition(
                with: cell.customView,
                duration: 0.5,
                options: .transitionFlipFromLeft,
                animations: {
                    cell.faceUp = !cell.faceUp
                    cell.updateWith(book: books[indexPath.row], showHints: self.showHints)
                    //rookCell.rookCardView.faceUp = !rookCell.rookCardView.faceUp
                    //rookCell.rookCardView.setNeedsDisplay()
            },
                completion: nil)
        }
    }
}





//– (void)flipCard
//    {
//        // grap the screen size and create a view with the same frame
//        // set its background to clear so it can be animated
//        UIWindow *mainWindow = [[[UIApplicationsharedApplication] delegate] window];
//        self.modalView = [[UIView alloc] initWithFrame:mainWindow.frame];
//        self.modalView.backgroundColor = [UIColorclearColor];
//        [mainWindow addSubview:self.modalView];
//        
//        // remove the tapToPresentCardGesture
//        // then add the tapToHideCardGesture both to the cell and the modal view
//        [self.contentView removeGestureRecognizer:self.tapToPresentCardGesture];
//        [self.contentView addGestureRecognizer:self.tapToHideCardGesture];
//        [self.modalView addGestureRecognizer:self.tapToHideCardGesture];
//        
//        // translate the frame of the cell to the main window
//        self.originalFrame = self.frame;
//        CGPoint translatedOrigin = [self convertPoint:self.bounds.origin toView:self.modalView];
//        self.translatedFrame = CGRectMake(translatedOrigin.x, translatedOrigin.y, self.frame.size.width, self.frame.size.height);
//        self.frame = self.translatedFrame;
//        
//        // add the cell to the modalView
//        [self.modalView addSubview:self];
//        
//        // flip the contentView while repositioning the actual cell view
//        [UIViewtransitionWithView:self.contentView
//            duration:0.5
//            options:UIViewAnimationOptionTransitionFlipFromLeft
//            
//            animations:^{
//                
//                // animate the backgroundColor of the modalView to a semi-transparent black
//                self.modalView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
//                
//                // move the cell to the center of the screen
//                self.center = mainWindow.center;
//                
//                // change the imageView to the card image
//                [self.cardImageView setImage:[UIImage imageNamed:@”AC”]];
//                
//            } completion:nil];
//}
