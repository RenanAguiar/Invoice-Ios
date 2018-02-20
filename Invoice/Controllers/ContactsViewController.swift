import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
}

class ContactsViewController: UITableViewController {
    
    var contacts = [Contact]()
    var client: Client?
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
      //  tableView.estimatedRowHeight = 140
        tableView.rowHeight = 75
        getContacts()
    }
    
    
    @IBAction func unwindToContacts(sender: UIStoryboardSegue) {        
        
        if let sourceViewController = sender.source as? ContactDetailViewController, let contact = sourceViewController.contact, let wasDeleted = sourceViewController.wasDeleted {
            
            if(wasDeleted) {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                self.contacts.remove(at: selectedIndexPath.row)
                tableView.deleteRows(at: [selectedIndexPath], with: .none)
                }
            }
            else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                contacts[selectedIndexPath.row] = contact
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: contacts.count, section: 0)
                contacts.append(contact)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Contacts"
        navigationItem.backBarButtonItem = backItem
        
        if  segue.identifier == "showContactDetail",
            let destination = segue.destination as? ContactDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow?.row
        {
            let contact = contacts[indexPath]
            destination.client = client
            destination.contact = contact
        }
            
        else if segue.identifier == "addContact", let destination = segue.destination as? ContactDetailViewController {
            destination.client = client
        }
        else {
            print("The selected cell is not being displayed by the table")
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let item = contacts[indexPath.row]
        cell.fullNameLabel.text = item.fullName
        cell.emailLabel.text = item.email
        cell.phoneLabel.text = item.phone
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
}


extension ContactsViewController {
    
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
                        self.contacts = (container?.result)!
                        self.contacts.sort() { $0.first_name < $1.first_name }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
        } )
    }
}
