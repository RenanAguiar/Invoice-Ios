//
//  ClientAddTableViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-10.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import UIKit

class ClientAddTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


}
extension ClientAddTableViewController {
    
    @IBAction func cancelToPlayersViewController(_ segue: UIStoryboardSegue) {
        print("a")
    }
    
    @IBAction func savePlayerDetail(_ segue: UIStoryboardSegue) {
        print("g")
    }
}
