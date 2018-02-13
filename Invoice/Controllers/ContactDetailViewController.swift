//
//  ContactDetailViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2018-01-18.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import UIKit

class ContactDetailViewController: UITableViewController {

    let numberOfRowsAtSection: [Int] = [4, 1]
    var numberOfSections = 2
    
    var meal: Contact?
    var client: Client?
    
    var contact = Contact(
        client_contact_id: nil, client_id: nil,first_name: "", last_name: "", email: "", phone: "")
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBAction func btnDelete(_ sender: Any) {
        showDelete()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        if (contact.client_contact_id) != nil {
            self.title = "Edit"
            txtFirstName.text = contact.first_name
            txtLastName.text = contact.last_name
            txtPhone.text = contact.phone
            txtEmail.text = contact.email
            print("sera")
            print(client!)
      
        }
        else {
            self.title = "New"
            numberOfSections = 1
            print("sera")
            print(client!)
        }
        
        
    }

    func deleteContact() {

        let client_contact_id : String! = "\(contact.client_contact_id!)"
        var endPoint: String
        

        endPoint = "api/contacts/"+client_contact_id+"/delete"
       
        
        makeRequest(endpoint: endPoint,
                    parameters: [:],
                    //    params: params,
            completionHandler: { (container : ApiContainer<Client>?, error : Error?) in
                if let error = error {
                    print("error calling POST on /getClients")
                    print(error)
                    return
                }
               // self.tableArray = (container?.result)!
               // DispatchQueue.main.async {
               //     self.tableView.reloadData()
               // }
        } )
       
    }
    
    func showDelete() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    
    let  deleteButton = UIAlertAction(title: "Delete Contact", style: .destructive, handler: { (action) -> Void in
    print("Delete button tapped")
        self.deleteContact()
    })
    
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
    print("Cancel button tapped")
    })

    alertController.addAction(deleteButton)
    alertController.addAction(cancelButton)
    
    self.navigationController!.present(alertController, animated: true, completion: nil)
    

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
tableView.sectionHeaderHeight = 50.0;
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveContact))
    }

    
    @objc func saveContact(sender: UIButton!) {

        let firstName = txtFirstName.text ?? ""
        let lastName = txtLastName.text ?? ""
        let email = txtEmail.text ?? ""
        let phone = txtPhone.text ?? ""
        let client_id = client?.client_id ?? nil
        var endPoint: String
        
        if (contact.client_contact_id) != nil {
            endPoint = "api/contacts/update"
        } else {
            endPoint = "api/contacts/add"
        }
        
        contact = Contact(client_contact_id: contact.client_contact_id, client_id: client_id,first_name: firstName, last_name: lastName, email: email, phone: phone)
        
        meal = contact
        var jsonData = Data()
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(contact)
            
        }
        catch {
        }

        makeRequestPost(endpoint: endPoint,
                        requestType: "POST",
                        requestBody: jsonData,
                        view: view,
                        completionHandler: { (response : ApiContainer<Contact>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                return
                            }
                            let b = (response?.meta)!
                            print(b.sucess)
                            let a = (response?.result[0])
                            let client_contact_id = a?.client_contact_id
                            self.contact.client_contact_id = client_contact_id
                            
                            if(b.sucess == "yes") {
                                
                                
                                let alert = UIAlertController(title: "Order Placed!", message: "Thank you for your order.\nWe'll ship it to you soon!", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                    (_)in
                                    self.performSegue(withIdentifier: "unwindToContacts", sender: self)
                                })
                                
                                alert.addAction(OKAction)
                                DispatchQueue.main.async(execute: {
                                    self.present(alert, animated: true, completion: nil)
                                    
                                })
                                
                                
                            }
                            else
                            {
                                DispatchQueue.main.async(execute: {
                                    let myAlert = UIAlertController(title: "Error", message: "Error creating Client", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                                return
                            }
        } )
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
