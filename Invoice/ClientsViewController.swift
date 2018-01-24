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
    
    
    var tableArray = [Client]()
    var meal: Client?
  
    var refresher: UIRefreshControl!
   
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
     
        
        if let sourceViewController = sender.source as? NTViewController, let meal = sourceViewController.meal2 {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
           
                // Update an existing meal.
                tableArray[selectedIndexPath.row] = meal
              
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                
            }
            else {
                // Add a new meal.
       
                let newIndexPath = IndexPath(row: tableArray.count, section: 0)
                tableArray.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            }
            tableArray.sort() { $0.name < $1.name }
          
        }
    }
    
    


    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        getClients()
        tableArray.sort() { $0.name < $1.name }
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
//tableView.tableFooterView = UIView(frame: rect)
        self.refreshControl?.addTarget(self, action: #selector(ClientsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)

        
        //  self.tableView.dataSource = self
        //  self.tableView.delegate = self
        
        getClients()
        

       
        
    }
    
    @objc func completeBorougArray() {
        getClients()
       // tableView.reloadData()
        refresher.endRefreshing()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "ShowDetail",
            let destination = segue.destination as? NTViewController,
            // let destination = segue.destination as? ClientDetailViewController,
            let blogIndex = tableView.indexPathForSelectedRow?.row
        {
            let client = tableArray[blogIndex]

            destination.client = client
        }
        
        else if segue.identifier == "AddItem" {
             print("add")
        }
            

            
        else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
    }
    
}



extension ClientsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)
        
        let item = tableArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.city + " - " + item.province
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
    
    func getClients() {
//        var params: [String: Any] = ["key 1": 1, "key 2": "value2"]
        makeRequest(endpoint: "api/clients/all",
                    parameters: [:],
                //    params: params,
                    completionHandler: { (container : ApiContainer<Client>?, error : Error?) in
                        if let error = error {
                            print("error calling POST on /getClients")
                            print(error)
                            return
                        }
                        self.tableArray = (container?.result)!
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
        } )
    }
    
    
}


