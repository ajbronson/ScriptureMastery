//
//  StringHelper.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/16/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import Foundation

extension String {
    func getStringArray() -> [String] {
        return self.components(separatedBy: " ")
    }
    
    func setFirstLetters() -> String {
        var stringToReturn = ""
        let newString = self.replacingOccurrences(of: "\n", with: "<br>")
        for string in newString.getStringArray() {
            var stringToUse = string
            var addNumberOfBreaks = 0
            if stringToUse == "<br>" {
                stringToReturn += "<br> "
                continue
            } else if stringToUse.contains("<br>") {
                while stringToUse.contains("<br>") {
                    if let range = stringToUse.range(of: "<br>") {
                        if range.upperBound == stringToUse.startIndex {
                            stringToReturn += "<br> "
                            stringToUse = stringToUse.substring(from: range.lowerBound)
                        } else if range.lowerBound == stringToUse.endIndex {
                            stringToUse = stringToUse.substring(to: range.upperBound)
                            addNumberOfBreaks += 1
                        }
                        else {
                            let separatedStrings = stringToUse.components(separatedBy: "<br>")
                            for i in 0..<(separatedStrings.count) {
                                if separatedStrings[i] == "" {
                                    stringToReturn += "<br> "
                                } else {
                                    if i == (separatedStrings.count - 1) {
                                        stringToReturn += ScriptureController.shared.getFirstLetterOfStringWithMultipleStrings(stringToUse: separatedStrings[i], addNumberOfBreaks: 0)
                                    } else {
                                        stringToReturn += ScriptureController.shared.getFirstLetterOfStringWithMultipleStrings(stringToUse: separatedStrings[i], addNumberOfBreaks: 1)
                                    }
                                }
                            }
                            break
                        }
                    }
                }
            } else {
                stringToReturn += ScriptureController.shared.getFirstLetterOfStringWithMultipleStrings(stringToUse: stringToUse, addNumberOfBreaks: addNumberOfBreaks)
            }
        }
        
        return stringToReturn
    }
    
    func getSections() -> [String] {
        let set = CharacterSet(charactersIn: ",.:;!?-\n")
        let replacedString = self.replacingOccurrences(of: "\n", with: "<br>")
        var stringArray = replacedString.components(separatedBy: set)
        var positionsToRemove: [Int] = []
        
        for i in 0..<stringArray.count {
            let currentString = stringArray[i]
            if currentString == "" || currentString == " " {
                positionsToRemove.append(i)
            }
        }
        
        for i in 0..<positionsToRemove.count {
            let position = positionsToRemove[i]
            stringArray.remove(at: position - i)
        }
        
        for i in 0..<stringArray.count {
            var currentString = stringArray[i]
            if i != stringArray.count - 1 {
                let nextString = stringArray[i + 1]
                if let last = currentString.characters.last,
                    let first = nextString.characters.first {
                    if last != " " && first != " " {
                        stringArray[i] += " "
                    }
                }
            }
        }
        
        return stringArray
    }
}
