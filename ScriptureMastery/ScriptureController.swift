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
        static let fileExtension = "sqlite2"
    }
    
    //MARK: - Singleton
    
    static let shared = ScriptureController()
    
    //MARK: - Properties
    
    var dbQueue: DatabaseQueue!
    
    
    fileprivate init() {
        dbQueue = try? DatabaseQueue(path: Bundle.main.path(forResource: Constant.fileName,
                                                            ofType: Constant.fileExtension)!)
    }
    
    let masterList = ["All Scripture Masteries", "Old Testament", "New Testament", "Book of Mormon", "Doctrine & Covenants", "Retired Scripture Masteries"]
}
