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
    
    
    @IBAction func unwindToInvoices(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? InvoiceViewController, let invoice = sourceViewController.invoice, let wasDeleted = sourceViewController.wasDeleted {
            
            if(wasDeleted) {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    self.invoices.remove(at: selectedIndexPath.row)
                    tableView.deleteRows(at: [selectedIndexPath], with: .none)
                }
            }
            else {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    invoices[selectedIndexPath.row] = invoice
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    let newIndexPath = IndexPath(row: invoices.count, section: 0)
                    invoices.append(invoice)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
    }
    
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
        var total: Decimal
        total = calculateSubTotalInvoice(invoiceItems: item.items)
        
        cell.invoiceIdLabel.text = item.invoice_number
        cell.dateIssueLabel.text = convertDate(date: item.date_issue)
        cell.dueDataLabel.text = convertDate(date: item.due_date)
        cell.statusLabel.text = item.status
        cell.amountLabel.text = formatCurrency(value: total)
        return cell
        
    }
    
    // TODO: redo this later (data convertion)
    func convertDate(date: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newFormat = DateFormatter()
        newFormat.dateFormat = "dd MMM yyyy"
        
        if let newDate = dateFormatter.date(from: (date)) {
            return newFormat.string(from: newDate)
        } else {
            return nil
        }
        
    }
    
    
    // MARK: REDO
    // TODO: make 1 function for both views to calculate values
    func calculateSubTotalInvoice(invoiceItems: [InvoiceItem]) -> Decimal {
        var subTotal: Decimal = 0.00
        for item in invoiceItems {
            subTotal += item.unit_price * item.quantity
        }
        return subTotal
    }
    
    // TODO: make 1 function for both views to calculate values
    func calculateTaxTotalInvoice(subTotalInvoice: Decimal) -> Decimal {
        var taxTotal: Decimal = 0.00
        taxTotal = subTotalInvoice * 0.05
        return taxTotal
    }
    
    // TODO: make 1 function for both views to calculate values
    func calculateTotalInvoice(invoiceItems: [InvoiceItem]) -> Decimal {
        var total: Decimal = 0.00
        var subTotalInvoice: Decimal = 0.00
        var taxTotalInvoice: Decimal = 0.00
        subTotalInvoice = calculateSubTotalInvoice(invoiceItems: invoiceItems)
        taxTotalInvoice = calculateTaxTotalInvoice(subTotalInvoice: subTotalInvoice)
        total = subTotalInvoice + taxTotalInvoice
        return total
        
        
    }
    //
    
    
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

