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
    
    func showHelpVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "helpVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSlaveView" {
            if let index = tableView.indexPathForSelectedRow,
                let volumes = volumes,
                let destinationVC = segue.destination as? SlaveTableViewController {
                if index.section == 0 {
                    destinationVC.updateSlave(volume: volumes[index.row], showHeader: index.row == 0 ? true : false)
                } else if index.section == 1 {
                    let starToPass = getStar(row: index.row)
                    if let books = starToPass.1 {
                        destinationVC.updateSlaveFromStar(books: books, title: starToPass.0, starColor: starToPass.2)
                    }
                }
            }
        }
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
    
    
}
