//
//  MasterTableViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
            return ScriptureController.shared.masterList.count
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell") else { return UITableViewCell() }
            cell.textLabel?.text = ScriptureController.shared.masterList[indexPath.row]
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell") else { return UITableViewCell() }
            cell.textLabel?.text = "Star"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSlaveView" {
            if let index = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? SlaveTableViewController {
                destinationVC.updateTitle(title: ScriptureController.shared.masterList[index.row])
            }
        }
    }
}
