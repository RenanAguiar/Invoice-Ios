//
//  ContactsViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2018-01-16.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
}




class ContactsViewController: UITableViewController {

    var tableArray = [Contact]()
    var client: Client?
    
    var refresher: UIRefreshControl!
    
    var contact: Contact?

    
    
    @IBAction func btnCancel(_ sender: Any) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
   
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getContacts()
        tableArray.sort() { $0.first_name < $1.first_name }
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
//                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        //        let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        //tableView.tableFooterView = UIView(frame: rect)
        self.refreshControl?.addTarget(self, action: #selector(ClientsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        
        //  self.tableView.dataSource = self
        //  self.tableView.delegate = self
        
        getContacts()
        
    }
    
    @objc func completeBorougArray() {
        getContacts()
        // tableView.reloadData()
        refresher.endRefreshing()
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let backItem = UIBarButtonItem()
        backItem.title = "Contacts"
        navigationItem.backBarButtonItem = backItem

        if  segue.identifier == "showContactDetail",
            let destination = segue.destination as? ContactDetailViewController,
            let blogIndex = tableView.indexPathForSelectedRow?.row
        {
            let contact = tableArray[blogIndex]
            destination.client = client
            destination.contact = contact
        }

        else if segue.identifier == "addContact", let destination = segue.destination as? ContactDetailViewController {
          //  destination.contact = contact!
            destination.client = client
            print("add")
        }



        else {
            print("The selected cell is not being displayed by the table")
        }

    }
    
    
    
    
    @IBAction func unwindToContacts(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ContactDetailViewController, let contact = sourceViewController.meal {

            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                tableArray[selectedIndexPath.row] = contact
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: tableArray.count, section: 0)
                tableArray.append(contact)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
    }
    
    
}



extension ContactsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        let item = tableArray[indexPath.row]
       // cell.textLabel?.text =  item.first_name + " " + item.last_name
      //  cell.detailTextLabel?.text = item.email
        
cell.lblName.text = item.first_name + " " + item.last_name
        cell.lblEmail.text = item.email
        cell.lblPhone.text = item.phone
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }

    func getContacts() {
        
   
        
        let client_id : String! = "\(client!.client_id!)"
        
        makeRequest(endpoint: "api/contacts/all",
                    parameters: ["client_id": client_id],
                    completionHandler: { (container : ApiContainer<Contact>?, error : Error?) in
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
