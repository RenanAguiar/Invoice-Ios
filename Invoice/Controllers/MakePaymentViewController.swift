//
//  MakePaymentViewController.swift
//  Invoice
//
//  Created by Renan Aguiar on 2018-03-07.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import UIKit

extension Float {
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

class MakePaymentViewController: UIViewController, AccessoryToolbarDelegate, UITextFieldDelegate {
    
    

    
    
    @IBOutlet weak var amountPaidTextField: UITextField!
    @IBOutlet weak var totalInvoiceTextField: UITextField!
    var thePicker = UIDatePicker()
    @IBOutlet weak var dateTransactionTextField: UITextField!
    var paid: Bool = false
    var amountPaid: Decimal = 0.00
    var totalInvoice: Decimal = 0.00
    var dateTransaction: String? = nil
     var invoice: Invoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.5
        totalInvoiceTextField.text = formatCurrency(value: totalInvoice, hideSymbol: true)
        
        dateTransactionTextField.delegate = self
        self.thePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.thePicker.backgroundColor = UIColor.white
        self.thePicker.datePickerMode = UIDatePickerMode.date
        
        setUpTextFieldPicker(textField: dateTransactionTextField)
        
        // TODO: redo this later (data convertion)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let vv = dateFormatter.string(from: Date())
        dateTransactionTextField.text = vv
        
        
        
        
        
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
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.enableNavigationBar()
        self.performSegue(withIdentifier: "unwindToInvoice", sender: self)
    }
    
    
    
    
    
    
    @IBAction func makePaymentButton(_ sender: Any) {
        

        var endPoint: String
        var date: String
       // var amountPaid: String

        let amountPaid = Decimal(string: amountPaidTextField.text!)
        
       // amountPaid = formatCurrency(value: result!, hideSymbol: true)!
    
        
        endPoint = "api/invoices/make_payment"


        
        
        date = dateToMySQL(dateTransactionTextField.text!)

        
        
        
        invoice = Invoice(invoice_id: invoice?.invoice_id, client_id: invoice?.client_id,amount_paid: amountPaid!, date_transaction: date
        )

        
        print(invoice!)
        let requestBody = makeJSONData(invoice)
        print("f")
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
                           // let responseData = (response?.result[0])
                           // let invoice_id = responseData?.invoice_id
                           // let invoice_number = responseData?.invoice_number
                           // let status = responseData?.status
                           // self.invoice?.invoice_id = invoice_id
                           // self.invoice?.invoice_number = invoice_number
                           // self.invoice?.status = status
                            
                            if(responseMeta.sucess == "yes") {
                                
                                let alert = UIAlertController(title: "Success!", message: "Invoice Saved!", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                    (_)in
                                    self.performSegue(withIdentifier: "unwindToInvoice", sender: self)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
