import UIKit

class InvoiceItemCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var unitPriceQuantityLabel: UILabel!
    @IBOutlet weak var lineTotalLabel: UILabel!
    
}

class InvoiceViewController: UIViewController, AccessoryToolbarDelegate,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateIssueTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateIssueTextField.delegate = self
        dueDateTextField.delegate = self
        
        self.thePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.thePicker.backgroundColor = UIColor.white
        self.thePicker.datePickerMode = UIDatePickerMode.date
        
        //data will be loaded from an API to a server. Hard Coded now just for testing
        setUpTextFieldPicker(textField: dateIssueTextField)
        setUpTextFieldPicker(textField: dueDateTextField)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 75
        self.title = "New"
        taxDescriptionLabel.text = "Tax @ 0%"
        
        if (invoice?.invoice_id) != nil {
            self.title = "Edit"
            //dueDateTextField.text = invoice?.due_date
           // dateIssueTextField.text = invoice?.date_issue
            
            // TODO: redo this later (data convertion)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let b = dateFormatter.date(from: (invoice?.due_date)!)
            
            dateFormatter.dateFormat = "dd MMM yyyy"
            let finalDate: String = dateFormatter.string(from: b!)
            dueDateTextField.text = finalDate
            
            
           // let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let bb = dateFormatter.date(from: (invoice?.date_issue)!)
            
            dateFormatter.dateFormat = "dd MMM yyyy"
            let finalDate2: String = dateFormatter.string(from: bb!)
            dateIssueTextField.text = finalDate2
            
            
            
            
            let taxDescription = invoice?.tax.description
            taxDescriptionLabel.text = "Tax @ \(taxDescription ?? "0")%"
            
            invoiceItems = (invoice?.items)!
            
            calculateSubTotalInvoice()
            calculateTaxTotalInvoice()
            calculateTotalInvoice()
          
            subTotalInvoiceLabel.text = subTotalInvoice.description
            taxTotalInvoiceLabel.text = taxTotalInvoice.description
            totalInvoiceLabel.text = totalInvoice.description
        }
        
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
            
            let partial = (item.unit_price?.description)!+" X "+(item.quantity?.description)!
            cell.unitPriceQuantityLabel.text = partial
            
            let lineTotal = item.unit_price * item.quantity
            cell.lineTotalLabel.text = lineTotal.description
            
            
            
            return cell
        }
        
        
        
    }
    
    func calculateSubTotalInvoice() {
        var subTotal: Decimal = 0.00
        for item in invoiceItems {
            subTotal = item.unit_price * item.quantity
            subTotalInvoice += subTotal
        }
    }
    
    func calculateTaxTotalInvoice() {
        var taxTotal: Decimal = 0.00
        taxTotal = subTotalInvoice * 0.05
        taxTotalInvoice = taxTotal
    }
    
    func calculateTotalInvoice() {
        var total: Decimal = 0.00
        total = subTotalInvoice + taxTotalInvoice
        totalInvoice = total
    }
    
    
    func doneClicked(for textField: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        //show on text field
        dateFormatter.dateFormat = "dd MMM yyyy"
        textField.text = dateFormatter.string(from: thePicker.date)
        
        //formated to store on mysql
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDate: String = dateFormatter.string(from: thePicker.date)
        print(finalDate)
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
    
    
    
}
