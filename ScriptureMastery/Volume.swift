//
//  Volume.swift
//  
//
//  Created by AJ Bronson on 12/16/16.
//
//

import Foundation
import GRDB

class Volume {
    let id: Int
    let name: String
    let retired: Bool
    
    init(row: Row) {
        id = row.value(named: "id")
        name = row.value(named: "name")
        retired = row.value(named: "retired")
    }
    
    init(id: Int, name: String, retired: Bool) {
        self.id = id
        self.name = name
        self.retired = retired
    }
}
