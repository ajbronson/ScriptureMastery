//
//  AppDelegate.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: This tries to copy the database even if it's already there.
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            if !fileManager.fileExists(atPath: "\(documentDirectory.absoluteString)\(ScriptureController.Constant.fileName).\(ScriptureController.Constant.fileExtension)") {
                let location = Bundle.main.path(forResource: ScriptureController.Constant.fileName, ofType: ScriptureController.Constant.fileExtension)!
                let newURL = documentDirectory.appendingPathComponent(ScriptureController.Constant.fileName).appendingPathExtension(ScriptureController.Constant.fileExtension)
                if let databaseURL = URL(string: "file://\(location)") {
                    do {
                        try fileManager.copyItem(at: databaseURL, to: newURL)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        return true
    }
}

