//
//  ClientsViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-10.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import UIKit
import Foundation

class ClientsViewController:  UITableViewController {
    
    var sortedFirstLetters: [String] = []
    var sections: [[Client]] = [[]]
    var tableArray = [Client]()
    var client: Client?
    var wasDeleted: Bool?
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var noClientsLabel: UILabel!
    @IBOutlet var noClientsView: UIView!
    
    @IBAction func unwindToClients(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ClientViewController,
            let client = sourceViewController.client,
            let wasDeleted = sourceViewController.wasDeleted {
            
            if(wasDeleted) {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    print("Delteted")
                    tableArray.remove(at: selectedIndexPath.row)
                    DispatchQueue.main.async {
                        // Deleting the row in the tableView
                        if self.tableView.numberOfRows(inSection: selectedIndexPath.section) > 1 {
                            self.tableView.deleteRows(at: [selectedIndexPath], with: UITableViewRowAnimation.bottom)
                        } else {
                            let indexSet = NSMutableIndexSet()
                            indexSet.add(selectedIndexPath.section)
                            self.tableView.deleteSections(indexSet as IndexSet, with: UITableViewRowAnimation.bottom)
                        }
                        
                    }
                }
                
            }
            else {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Update an existing client.
                    tableArray[selectedIndexPath.row] = client
                    tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                }
                else {
                    // Add a client.
                    tableArray.append(client)
                    
                }
            }
            
            prepareData()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondScene = segue.destination as! ClientViewController
        if segue.identifier == "ShowDetail", let indexPath = self.tableView.indexPathForSelectedRow {
            let currentPhoto = sections[indexPath.section][indexPath.row]
            secondScene.client = currentPhoto
        }
        else if segue.identifier == "AddItem" {
            print("add")
        }
        else {
            fatalError("The selected cell is not being displayed by the table")
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // refreshControl.beginRefreshing()
        getClients()
        //  DispatchQueue.main.async {
        // refreshControl.endRefreshing()
        // }
    }
    
}

extension ClientsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(ClientsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.backgroundView = nil
        noClientsLabel.text = ""
        
        getClients() //for only the 1st time ==> when view is created ==> ok ish
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // getClients() // not a good idea to make a request to the server everytime the view appears on the screen.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(self.tableArray.count > 0) {
            return sortedFirstLetters[section]
        }
        else {
            return ""
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        print(sortedFirstLetters)
        return sortedFirstLetters
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)
        cell.textLabel?.text = name.name
        cell.detailTextLabel?.text = name.city + " - " + name.province
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(sections[section].count > 0) {
            //            tableView.backgroundView = nil
            //            tableView.backgroundView?.isHidden = true
            //            noClientsLabel.text = ""
        } else {
            //            tableView.backgroundView = noClientsView
            //            tableView.backgroundView?.isHidden = false
            //            noClientsLabel.text = "bNo Clients"
        }
        return sections[section].count
    }
    
    func getClients() {
        print("called server")
        
        self.refreshControl?.beginRefreshing()
        
        
        
        self.tableView.setContentOffset(CGPoint(x:0, y:-100), animated: true)
        
        makeRequest(endpoint: "api/clients/all",
                    parameters: [:],
                    completionHandler: { (container : ApiContainer<Client>?, error : Error?) in
                        if let error = error {
                            print("error calling POST on /getClients")
                            print(error)
                            return
                        }
                        self.tableArray = (container?.result)!
                        
                        self.prepareData()
                        DispatchQueue.main.async {
                            if(self.tableArray.isEmpty)
                            {
                                self.noClientsLabel.text = "bNo Clients"
                                self.tableView.backgroundView?.isHidden = false
                                self.noClientsLabel.text = ""
                                print("tudo")
                            }
                            else{
                                
                                print("nada")
                            }
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
        } )
    }
    
    //sorts and makes the index
    func prepareData() {
        let firstLetters = self.tableArray.map { $0.nameFirstLetter }
        let uniqueFirstLetters = Array(Set(firstLetters))
        
        self.sortedFirstLetters = uniqueFirstLetters.sorted()
        self.sections = self.sortedFirstLetters.map { firstLetter in
            return self.tableArray
                .filter { $0.nameFirstLetter == firstLetter }
                .sorted { $0.name < $1.name }
        }
    }
    
}