//
//  ScriptureController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import Foundation
import GRDB

class ScriptureController {
    
    //MARK: - Constants
    
    struct Constant {
        static let fileName = "SMDB"
        static let fileExtension = "db"
    }
    
    //MARK: - Singleton
    
    static let shared = ScriptureController()
    
    //MARK: - Properties
    
    var dbQueue: DatabaseQueue!
    
    
    fileprivate init() {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            dbQueue = try? DatabaseQueue(path: "\(documentDirectory.absoluteString)\(ScriptureController.Constant.fileName).\(ScriptureController.Constant.fileExtension)")
        }
    }
    
    let masterList = ["All Scripture Masteries", "Old Testament", "New Testament", "Book of Mormon", "Doctrine & Covenants", "Retired Scripture Masteries"]
    
    func getAllCanons() {
        
    }
    
    func volumes() -> [Volume] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Volume] in
            var volumes: [Volume] = []
            
            for row in try Row.fetchAll(db, "select * from canon where retired = 0") {
                volumes.append(Volume(row: row))
            }
            return volumes
        })
    }
    
    func book(volumeID: Int) -> [Book] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Book] in
            var books: [Book] = []
            
            if volumeID == 0 {
                for row in try Row.fetchAll(db, "select * from scriptures s JOIN canon c ON (s.canon_id = c.id) where c.retired = 1 order by s.canon_id") {
                    books.append(Book(row: row))
                }
            } else if volumeID == 1 {
                for row in try Row.fetchAll(db, "select * from scriptures order by canon_id") {
                    books.append(Book(row: row))
                }
            } else {
                for row in try Row.fetchAll(db, "select * from scriptures where canon_id = \(volumeID) order by id") {
                    books.append(Book(row: row))
                }
            }
            return books
        })
    }
    
    func greenStars() -> [Book] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Book] in
            var books: [Book] = []
            
            for row in try Row.fetchAll(db, "select * from scriptures where has_green_star = 1") {
                books.append(Book(row: row))
            }
            return books
        })
    }
    
    func yellowStars() -> [Book] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Book] in
            var books: [Book] = []
            
            for row in try Row.fetchAll(db, "select * from scriptures where has_yellow_star = 1") {
                books.append(Book(row: row))
            }
            return books
        })
    }
    
    func blueStars() -> [Book] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Book] in
            var books: [Book] = []
            
            for row in try Row.fetchAll(db, "select * from scriptures where has_blue_star = 1") {
                books.append(Book(row: row))
            }
            return books
        })
    }
    
    func updateBookStar() {
        
    }
    
    func updateBookStar(book: Book, hasYellowStar: Int, hasBlueStar: Int, hasGreenStar: Int) {
        dbQueue.inDatabase { (db: Database) -> Void in
            let me = try? db.makeUpdateStatement("UPDATE scriptures SET has_yellow_star = \(hasYellowStar), has_blue_star = \(hasBlueStar), has_green_star = \(hasGreenStar) WHERE id = \(book.id)")
            try? me?.execute()
        }
    }
}
