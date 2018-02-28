import UIKit

class InvoiceCell: UITableViewCell {

    @IBOutlet weak var invoiceIdLabel: UILabel!
    @IBOutlet weak var dueDataLabel: UILabel!
    @IBOutlet weak var dateIssueLabel: UILabel!    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
}


class InvoicesViewController: UITableViewController {
    
    var invoices = [Invoice]()
    var client: Client?
    var invoice: Invoice?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 150
        

        getInvoices()
    }
    
    
//    @IBAction func unwindToContacts(sender: UIStoryboardSegue) {
//        
//        if let sourceViewController = sender.source as? ContactDetailViewController, let contact = sourceViewController.contact, let wasDeleted = sourceViewController.wasDeleted {
//            
//            if(wasDeleted) {
//                if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                    self.invoices.remove(at: selectedIndexPath.row)
//                    tableView.deleteRows(at: [selectedIndexPath], with: .none)
//                }
//            }
//            else {
//                if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                    invoices[selectedIndexPath.row] = contact
//                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
//                }
//                else {
//                    let newIndexPath = IndexPath(row: invoices.count, section: 0)
//                    invoices.append(contact)
//                    tableView.insertRows(at: [newIndexPath], with: .automatic)
//                }
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Invoices"
        navigationItem.backBarButtonItem = backItem

        if  segue.identifier == "showInvoiceDetail",
            let destination = segue.destination as? InvoiceViewController,
            let indexPath = tableView.indexPathForSelectedRow?.row
        {
            let invoice = invoices[indexPath]
            destination.client = client
            destination.invoice = invoice
        }

        else if segue.identifier == "addInvoice", let destination = segue.destination as? InvoiceViewController {
            print("addd")
            destination.client = client
        }
        else {
            print("The selected cell is not being displayed by the table")
        }
    }
    
 

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell", for: indexPath) as! InvoiceCell
        let item = invoices[indexPath.row]
       // let invoice_id : String! = "\(item.invoice_id!)"
       cell.invoiceIdLabel.text = item.invoice_number
       // cell.invoiceIdLabel.text = invoice_id
        cell.dateIssueLabel.text = item.date_issue
        cell.dueDataLabel.text = item.due_date
        cell.statusLabel.text = "Overdue"
        //cell.statusLabel.text = item.status
        return cell

    }


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoices.count
    }
    
}


extension InvoicesViewController {
    
    func getInvoices() {
        let client_id : String! = "\(client!.client_id!)"
        makeRequest(endpoint: "api/invoices/all",
                    parameters: ["client_id": client_id],
                    completionHandler: { (container : ApiContainer<Invoice>?, error : Error?) in
                        if let error = error {
                            print("error calling POST on /getInvoices")
                            print(error)
                            return
                        }
                        self.invoices = (container?.result)!
                       // self.contacts.sort() { $0.first_name < $1.first_name }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
        } )
    }
}

