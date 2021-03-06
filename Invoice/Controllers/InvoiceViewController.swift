import UIKit

class InvoiceItemCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var unitPriceQuantityLabel: UILabel!
    @IBOutlet weak var lineTotalLabel: UILabel!
    
}


class InvoiceViewController: UIViewController, AccessoryToolbarDelegate,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateIssueTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taxDescriptionLabel: UILabel!
    @IBOutlet weak var subTotalInvoiceLabel: UILabel!
    @IBOutlet weak var taxTotalInvoiceLabel: UILabel!
    @IBOutlet weak var totalInvoiceLabel: UILabel!
    
    var thePicker = UIDatePicker()
    var invoice: Invoice?
    var client: Client?
    var invoiceItems : [InvoiceItem] = [InvoiceItem]()
    var subTotalInvoice: Decimal = 0.00
    var taxTotalInvoice: Decimal = 0.00
    var totalInvoice: Decimal = 0.00
    var modalType: String?
    
    var wasDeleted: Bool? = false
    


    
    @IBAction func saveInvoice(_ sender: Any) {
        let client_id = client?.client_id ?? nil
        var endPoint: String
        var dateIssue: String
        var dueDate: String
        
        if (invoice?.invoice_id) != nil {
            endPoint = "invoices/update"
        } else {
            endPoint = "invoices/add"
        }
        
        dueDate = dateToMySQL(dueDateTextField.text!)
        dateIssue = dateToMySQL(dateIssueTextField.text!)
        let unitPrice = taxTextField.text ?? "0.00"
        let tax = Decimal(string: unitPrice) ?? 0.00
        
        invoice = Invoice(invoice_id: invoice?.invoice_id, client_id: client_id, tax: tax, date_issue: dateIssue, due_date: dueDate,
                          status: "Draft",
                          items: invoiceItems
        )
        
        let requestBody = makeJSONData(invoice)
        
        makeRequestPost(endpoint: endPoint,
                        requestType: "POST",
                        requestBody: requestBody,
                        view: view,
                        completionHandler: { (response : ApiContainer<Invoice>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                return
                            }
                            let responseMeta = (response?.meta)!
                            let responseData = (response?.result[0])
                            let invoice_id = responseData?.invoice_id
                            let invoice_number = responseData?.invoice_number
                            let status = responseData?.status
                            self.invoice?.invoice_id = invoice_id
                            self.invoice?.invoice_number = invoice_number
                            self.invoice?.status = status
                            
                            if(responseMeta.sucess == "yes") {
                                let alert = UIAlertController(title: "Success!", message: "Invoice Saved!", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                    (_)in
                                    self.performSegue(withIdentifier: "unwindToInvoices", sender: self)
                                })
                                
                                alert.addAction(OKAction)
                                DispatchQueue.main.async(execute: {
                                    self.present(alert, animated: true, completion: nil)
                                    
                                })
                            }
                            else
                            {
                                DispatchQueue.main.async(execute: {
                                    let myAlert = UIAlertController(title: "Error", message: "Error creating Invoice", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                                return
                            }
        } )
        
        
    }
    
// MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        dateIssueTextField.delegate = self
        dueDateTextField.delegate = self
        
        self.thePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.thePicker.backgroundColor = UIColor.white
        self.thePicker.datePickerMode = UIDatePickerMode.date
        
        setUpTextFieldPicker(textField: dateIssueTextField)
        setUpTextFieldPicker(textField: dueDateTextField)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 75
        self.title = "New"
        //taxDescriptionLabel.text = "Tax @ 0%"
        
        // TODO: redo this later (data convertion)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let vv = dateFormatter.string(from: Date())
        dateIssueTextField.text = vv
        
        //self.navigationController?.delegate = self
        
        taxTextField.text =  DAKeychain.shared["tax"]
        
        if (invoice?.invoice_id) != nil {
            self.title = "Edit"
            // TODO: redo this later (data convertion)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let b = dateFormatter.date(from: (invoice?.due_date)!) {
                dateFormatter.dateFormat = "dd MMM yyyy"
                let finalDate: String = dateFormatter.string(from: b)
                dueDateTextField.text = finalDate
            }
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let bb = dateFormatter.date(from: (invoice?.date_issue)!) {
                dateFormatter.dateFormat = "dd MMM yyyy"
                let finalDate2: String = dateFormatter.string(from: bb)
                dateIssueTextField.text = finalDate2
            }
            
           // let taxDescription = invoice?.tax
            taxTextField.text =  invoice?.tax.description
           // taxDescriptionLabel.text = "Tax @ \(taxDescription ?? "0")%"
            invoiceItems = (invoice?.items)!
            calculateTotalInvoice()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enableNavigationBar()
    }
  

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath as NSIndexPath).row == (invoiceItems.count)) {
            return 50
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == (invoiceItems.count)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceAddCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceItemCell", for: indexPath) as! InvoiceItemCell
            let item = invoiceItems[indexPath.row]
            
            cell.descriptionLabel.text = item.description
            
            let unitPrice = formatCurrency(value: item.unit_price)
            
            let partial = (unitPrice)!+" X "+(item.quantity?.description)!
            cell.unitPriceQuantityLabel.text = partial
            
            let lineTotal = item.unit_price * item.quantity
            cell.lineTotalLabel.text = formatCurrency(value: lineTotal)
            
            
            
            
            return cell
        }
        
        
        
    }
    // MARK: REDO
    // TODO: make 1 function for both views to calculate values
    func calculateSubTotalInvoice() {
        var subTotal: Decimal = 0.00
        for item in invoiceItems {
            subTotal += item.unit_price * item.quantity
        }
        subTotalInvoice = subTotal
    }
    
    // TODO: make 1 function for both views to calculate values
    func calculateTaxTotalInvoice() {
        var taxTotal: Decimal = 0.00
        let tax = Decimal(string: taxTextField.text!)!/100
        taxTotal = subTotalInvoice * tax
        taxTotalInvoice = taxTotal
    }
    
    // TODO: make 1 function for both views to calculate values
    func calculateTotalInvoice() {
        var total: Decimal = 0.00
        calculateSubTotalInvoice()
        calculateTaxTotalInvoice()
        total = subTotalInvoice + taxTotalInvoice
        totalInvoice = total
        
        subTotalInvoiceLabel.text = formatCurrency(value: subTotalInvoice)
        taxTotalInvoiceLabel.text = formatCurrency(value: taxTotalInvoice)
        totalInvoiceLabel.text = formatCurrency(value: totalInvoice)
        
    }
    
    
    func doneClicked(for textField: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        //show on text field
        dateFormatter.dateFormat = "dd MMM yyyy"
        textField.text = dateFormatter.string(from: thePicker.date)
        
        textField.resignFirstResponder()
    }
    
    func cancelClicked(for textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func setUpTextFieldPicker(textField: UITextField) {
        textField.inputView = thePicker
        let toolbar = AccessoryToolbar(for: textField)
        toolbar.accessoryDelegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let fullDate = dateFormatter.date(from: textField.text!) {
            thePicker.date = fullDate
        } else {
            thePicker.date = Date()
        }
        
        return true
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Items"
       
        
        if  segue.identifier == "showItem",
            let destination = segue.destination as? InvoiceItemViewController,
            let indexPath = tableView.indexPathForSelectedRow?.row
        {
            let item = invoiceItems[indexPath]
            destination.client = client
            destination.invoice = invoice
            destination.invoiceItem = item
        }
            
        else if segue.identifier == "addItem", let destination = segue.destination as? InvoiceItemViewController {
            destination.client = client
            destination.invoice = invoice
        }
        else if segue.identifier == "showModalInvoice", let destination = segue.destination as? ModalInvoiceViewController {
            destination.totalInvoice = totalInvoice
            destination.invoice = invoice
            destination.modalType = modalType
            self.disableNavigationBar()
        }
        else if segue.identifier == "showPreview", let destination = segue.destination as? InvoicePreviewViewController {
            destination.invoice = invoice
            backItem.title = "Invoice"
           
        }
        else {
            print("The selected cell is not being displayed by the table")
        }
        
         navigationItem.backBarButtonItem = backItem
    }
    
    
    
    @IBAction func unwindToInvoice(sender: UIStoryboardSegue) {
        
        
        if let sourceViewController = sender.source as? InvoiceItemViewController,
            let invoiceItem = sourceViewController.invoiceItem,
            let wasDeleted = sourceViewController.wasDeleted {
            
            if(wasDeleted) {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    self.invoiceItems.remove(at: selectedIndexPath.row)
                    tableView.deleteRows(at: [selectedIndexPath], with: .none)
                }
            }
            else {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    if (selectedIndexPath.row == (invoiceItems.count)) {
                        let newIndexPath = IndexPath(row: invoiceItems.count, section: 0)
                        invoiceItems.append(invoiceItem)
                        tableView.insertRows(at: [newIndexPath], with: .automatic)
                    } else {
                        invoiceItems[selectedIndexPath.row] = invoiceItem
                        tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    }
                }
                
            }
            calculateTotalInvoice()
            
        } else if let sourceViewController = sender.source as? ModalInvoiceViewController {
            let isSuccess = sourceViewController.isSuccess
            let amountPaid = sourceViewController.text
            let dateTransaction = sourceViewController.date
            invoice = sourceViewController.invoice
            self.enableNavigationBar()
            if(isSuccess) {
                invoice?.amount_paid = amountPaid
                invoice?.date_transaction = dateTransaction
            }
  
        }

    }
    
    
    
    
    
    @IBAction func showActionAlert(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        
        let previewButton = UIAlertAction(title: "Preview", style: .default, handler: { action in
            self.performSegue(withIdentifier: "showPreview", sender: self)
            
        })
        
        let payButton = UIAlertAction(title: "Make Payment", style: .default, handler: { action in
            self.modalType = "makePayment"
            self.performSegue(withIdentifier: "showModalInvoice", sender: self)
            
        })
        
        let voidButton = UIAlertAction(title: "Void", style: .destructive, handler: { action in
             self.modalType = "void"
            self.performSegue(withIdentifier: "showModalInvoice", sender: self)})
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })

        alertController.addAction(previewButton)
        alertController.addAction(payButton)
        alertController.addAction(voidButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)

    }
    
    
}

