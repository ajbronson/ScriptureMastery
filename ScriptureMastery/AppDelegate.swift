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
        
        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
        }
        
        if UserDefaults.standard.value(forKey: ScriptureController.Constant.fontSize) == nil {
            UserDefaults.standard.set(100, forKey: ScriptureController.Constant.fontSize)
        }
        
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
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        if let navVC = primaryViewController as? UINavigationController {
            for controller in navVC.viewControllers {
                if controller.restorationIdentifier == "detailVC" {
                    return controller
                }
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "detailVC")
        
        return detailView
    }
}

