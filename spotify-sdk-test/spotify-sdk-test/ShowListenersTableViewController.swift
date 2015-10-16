//
//  ShowListenersTableViewController.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/17/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class ShowListenersTableViewController: UITableViewController {
    
    weak var backButtonDelegate : BackButtonDelegate!
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        backButtonDelegate?.backButtonPressedFrom(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
}
