//
//  SlaveTableViewController.swift
//  ScriptureMastery
//
//  Created by AJ Bronson on 12/9/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveTableViewController: UITableViewController {
    
    var showHints = false
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "slaveCell") else { return UITableViewCell() }
        cell.textLabel?.text = "Moses 1:39"
        cell.detailTextLabel?.text = showHints ? "This is my Hint" : ""
        return cell
    }

    func updateTitle(title: String) {
        self.title = title
    }
    
    @IBAction func hintButtonTapped(_ sender: UIBarButtonItem) {
        sender.title = showHints ? "Show Hints" : "Hide Hints"
        showHints = !showHints
        tableView.reloadData()
    }
}
