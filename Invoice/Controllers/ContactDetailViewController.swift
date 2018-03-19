
import UIKit

class ContactDetailViewController: UITableViewController {

    let numberOfRowsAtSection: [Int] = [4, 1]
    var numberOfSections = 1
    
    var contact: Contact?
    var client: Client?
    
    var wasDeleted: Bool? = false
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
// MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderHeight = 50.0;
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveContact))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "New"
        numberOfSections = 1
        if (contact?.client_contact_id) != nil {
            self.title = "Edit"
            firstNameTextField.text = contact?.first_name
            lastNameTextField.text = contact?.last_name
            phoneTextField.text = contact?.phone
            emailTextField.text = contact?.email
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
            print(rows)
        }
        return rows
    }


}


extension ContactDetailViewController {
    
    @objc func saveContact(sender: UIButton!) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let client_id = client?.client_id ?? nil
        var endPoint: String
        
        if (contact?.client_contact_id) != nil {
            endPoint = "contacts/update"
        } else {
            endPoint = "contacts/add"
        }
        
        contact = Contact(client_contact_id: contact?.client_contact_id, client_id: client_id,first_name: firstName, last_name: lastName, email: email, phone: phone)
        let requestBody = makeJSONData(contact)

        makeRequestPost(endpoint: endPoint,
                        requestType: "POST",
                        requestBody: requestBody,
                        view: view,
                        completionHandler: { (response : ApiContainer<Contact>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                return
                            }
                            let responseMeta = (response?.meta)!
                            let responseData = (response?.result[0])
                            let client_contact_id = responseData?.client_contact_id
                            self.contact?.client_contact_id = client_contact_id
                            
                            if(responseMeta.sucess == "yes") {
                                let alert = UIAlertController(title: "Success!", message: "Contact Saved!", preferredStyle: .alert)
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
                                    let myAlert = UIAlertController(title: "Error", message: "Error creating Contact", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                                return
                            }
        } )
        
    }
    
    @IBAction func deleteContactConfirm(_ sender: Any) {
        showDeleteAlert()
    }
    
    func showDeleteAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete Contact", style: .destructive, handler: { (action) -> Void in
            self.deleteContact()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func deleteContact() {
        let client_id : String! = "\(contact!.client_contact_id!)"
        var endPoint: String
        endPoint = "contacts/"+client_id+"/delete"
        makeDelete(httpMethod: "DELETE",endpoint: endPoint,
                   parameters: [:],
                   completionHandler: { (container : Meta?, error : BackendError?) in
                    if let error = error {
                        print("error on /delete")
                        let message: String
                        switch error {
                        case let .objectDeletion(reason):
                            message = reason
                        default:
                            message = "ERROR"
                        }
                        self.showAlert(title: "Error", message: message)
                        return
                    }
                    self.wasDeleted = true
                    
                    //change message and use the custom func like on error.
                    let alert = UIAlertController(title: "Success!", message: "Contact Deleted.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (_)in
                        self.performSegue(withIdentifier: "unwindToContacts", sender: self)
                    })
                    alert.addAction(OKAction)
                    
                    DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true, completion: nil)
                    })
                    
        }  )
        
    }
    
}
