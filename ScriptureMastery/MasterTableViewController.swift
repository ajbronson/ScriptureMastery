//
//  MasterTableViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var volumes: [Volume]?
    var greenStars: [Book]?
    var yellowStars: [Book]?
    var blueStars: [Book]?
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.volumes = ScriptureController.shared.volumes()
        let retiredVolume = Volume(id: 0, name: "Retired Scr Masteries", retired: true)
        volumes?.append(retiredVolume)
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showHelpVC), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.leftBarButtonItem = infoBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.greenStars = ScriptureController.shared.greenStars()
        self.blueStars = ScriptureController.shared.blueStars()
        self.yellowStars = ScriptureController.shared.yellowStars()
        tableView.reloadData()
        navigationController?.toolbar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let count = UserDefaults.standard.integer(forKey: "launchCount")
        
        if count == 3 {
            let alert = UIAlertController(title: "Like the app?", message: "Please spend 1 minute writing a brief review!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "No Thanks", style: .cancel) { (action) in
                if let id = UIDevice.current.identifierForVendor?.uuidString {
                    Flurry.logEvent("Declined Invitation To Review", withParameters: ["Unique ID" : id])
                } else {
                    Flurry.logEvent("Declined Invitation To Review", withParameters: ["Unique ID" : "Unknown"])
                }
            }
            let okAction = UIAlertAction(title: "Sure!", style: .default) { (action) in
                if let id = UIDevice.current.identifierForVendor?.uuidString {
                    Flurry.logEvent("Accepted Invitation To Review", withParameters: ["Unique ID" : id])
                } else {
                    Flurry.logEvent("Accepted Invitation To Review", withParameters: ["Unique ID" : "Unknown"])
                }
                
                if let url = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=389594409&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
                    UIApplication.shared.openURL(url)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - TableView Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let green = greenStars,
            let blue = blueStars,
            let yellow = yellowStars, green.count > 0 || blue.count > 0 || yellow.count > 0 {
            return 2
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Categories"
        case 1:
            return "Stars"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return volumes?.count ?? 0
        case 1:
            
            var starCount = 0
            
            if let green = greenStars,
                green.count > 0 {
                starCount += 1
            }
            
            if let blue = blueStars,
                blue.count > 0 {
                starCount += 1
            }
            
            if let yellow = yellowStars,
                yellow.count > 0 {
                starCount += 1
            }
            
            return starCount
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
        return CGFloat(textSize)/2.5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell") else { return UITableViewCell() }
            cell.textLabel?.text = volumes?[indexPath.row].name
            let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
            cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(textSize)/6.2)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell") else { return UITableViewCell() }
            cell.textLabel?.text = getStar(row: indexPath.row).0
            let textSize = UserDefaults.standard.integer(forKey: ScriptureController.Constant.fontSize)
            cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(textSize)/6.2)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    //MARK: - Helper Methods
    
    func showHelpVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "helpVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getStar(row: Int) -> (String, [Book]?, Star.Color) {
        var rows: [Int] = []
        
        if let green = greenStars,
            green.count > 0 {
            rows.append(0)
        }
        
        if let blue = blueStars,
            blue.count > 0 {
            rows.append(1)
        }
        
        if let yellow = yellowStars,
            yellow.count > 0 {
            rows.append(2)
        }
        
        if row == 0 {
            if rows.contains(0) {
                return ("Green Stars", greenStars, Star.Color.Green)
            } else if rows.contains(1) {
                return ("Blue Stars", blueStars, Star.Color.Blue)
            } else if rows.contains(2) {
                return ("Yellow Stars", yellowStars, Star.Color.Yellow)
            }
        } else if row == 1 {
            if rows.contains(0) && rows.contains(1) {
                return ("Blue Stars", blueStars, Star.Color.Blue)
            }
            else if rows.contains(2) {
                return ("Yellow Stars", yellowStars, Star.Color.Yellow)
            }
            
        } else if row == 2 {
            return ("Yellow Stars", yellowStars, Star.Color.Yellow)
        }
        
        return ("", nil, Star.Color.White)
    }
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSlaveView" {
            if let index = tableView.indexPathForSelectedRow,
                let volumes = volumes,
                let destinationVC = segue.destination as? SlaveTableViewController {
                if index.section == 0 {
                    var show = false
                    if index.row == 0 || index.row == 5 {
                        show = true
                    }
                    destinationVC.updateSlave(volume: volumes[index.row], showHeader: show)
                } else if index.section == 1 {
                    let starToPass = getStar(row: index.row)
                    
                    if let books = starToPass.1 {
                        destinationVC.updateSlaveFromStar(books: books, title: starToPass.0, starColor: starToPass.2)
                    }
                }
            }
        }
    }
}
