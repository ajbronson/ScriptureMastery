//
//  AppDelegate.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaults.standard.value(forKey: ScriptureController.Constant.fontSize) == nil {
            UserDefaults.standard.set(100, forKey: ScriptureController.Constant.fontSize)
        }
        let fileManager = FileManager.default
        let documentsURL = try! FileManager().url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
        let databasePath = documentsURL.appendingPathComponent("\(ScriptureController.Constant.fileName).\(ScriptureController.Constant.fileExtension)")
        
        if !FileManager().fileExists(atPath: databasePath.path) {
            let location = Bundle.main.path(forResource: ScriptureController.Constant.fileName, ofType: ScriptureController.Constant.fileExtension)!
            let newURL = documentsURL.appendingPathComponent(ScriptureController.Constant.fileName).appendingPathExtension(ScriptureController.Constant.fileExtension)
            
            if let databaseURL = URL(string: "file://\(location)") {
                do {
                    try fileManager.copyItem(at: databaseURL, to: newURL)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }

        }
        
        return true
    }
}

