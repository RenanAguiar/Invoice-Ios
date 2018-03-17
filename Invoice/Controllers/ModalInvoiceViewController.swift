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

class ModalInvoiceViewController: UIViewController, AccessoryToolbarDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var rightHandLabel: UILabel!
    

    var isSuccess = false
    var text: Decimal = 0.00
    var totalInvoice: Decimal = 0.00
    var date: String? = nil
    var invoice: Invoice?
    var thePicker = UIDatePicker()
    var modalType: String? = "Void"

    
    func prepareView() {
        if modalType == "void" {
            titleLabel.text = "Void Invoice"
            rightHandLabel.text = "Notes"
            textTextField.keyboardType = .asciiCapable
        } else {
            titleLabel.text = "Make Payment"
            rightHandLabel.text = "Amount"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.5
        textTextField.text = formatCurrency(value: totalInvoice, hideSymbol: true)
        
        dateTextField.delegate = self
        self.thePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.thePicker.backgroundColor = UIColor.white
        self.thePicker.datePickerMode = UIDatePickerMode.date
        
        setUpTextFieldPicker(textField: dateTextField)
        
        // TODO: redo this later (data convertion)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let vv = dateFormatter.string(from: Date())
        dateTextField.text = vv
        
        
        prepareView()
        
        
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
      //  parent?.enableNavigationBar()
        self.performSegue(withIdentifier: "unwindToInvoice", sender: self)
    }
    
    

    
    
    
    @IBAction func makePaymentButton(_ sender: Any) {

        var endPoint: String
        var date: String
        let amountPaid = Decimal(string: textTextField.text!)

        if(modalType == "void") {
            let note: String = textTextField.text!
            endPoint = "invoices/void_invoice"
            invoice = Invoice(invoice_id: invoice?.invoice_id, client_id: invoice?.client_id,note: note)
        } else {
            date = dateToMySQL(dateTextField.text!)
            endPoint = "invoices/make_payment"
            invoice = Invoice(invoice_id: invoice?.invoice_id, client_id: invoice?.client_id,amount_paid: amountPaid!, date_transaction: date)
        }
        
        

        

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
                            let status = responseData?.status
                            self.invoice?.status = status
                            
                            if(responseMeta.sucess == "yes") {
                                self.isSuccess = true
                                let alert = UIAlertController(title: "Success!", message: "Payment Saved!", preferredStyle: .alert)
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
                                    let myAlert = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                                return
                            }
        } )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
