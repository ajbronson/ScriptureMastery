//
//  Book.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/16/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import Foundation
import GRDB

class Book: Equatable {
    
    //MARK: - Properties
    
    let id: Int
    let reference: String
    let text: String
    let hint: String
    let canonID: Int
    var blueStar: Bool?
    var greenStar: Bool?
    var yellowStar: Bool?
    var memorized: Bool?
    
    //MARK: - Initializer
    
    init(row: Row) {
        id = row.value(named: "id")
        reference = row.value(named: "ref")
        text = row.value(named: "text")
        hint = row.value(named: "summary")
        canonID = row.value(named: "canon_id")
        blueStar = row.value(named: "has_blue_star")
        greenStar = row.value(named: "has_green_star")
        yellowStar = row.value(named: "has_yellow_star")
        memorized = row.value(named: "memorized")
    }
}

//MARK: - Equatable 

func ==(rhs: Book, lhs: Book) -> Bool {
    return rhs.id == lhs.id
}
