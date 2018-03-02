//
//  InvoiceItemViewController.swift
//  Invoice
//
//  Created by Renan Aguiar on 2018-03-01.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import UIKit


class InvoiceItemViewController: UIViewController, UITextFieldDelegate {

    var contact: Contact?
    var client: Client?
    var invoice: Invoice?
    var invoiceItem: InvoiceItem?
    
    var wasDeleted: Bool? = false
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quantityTextField.delegate = self
        unitPriceTextField.delegate = self
        
        self.title = "New"
        if (invoiceItem?.invoice_detail_id) != nil {
            self.title = "Edit"
            descriptionTextField.text = invoiceItem?.description
            quantityTextField.text = invoiceItem?.quantity.description
            unitPriceTextField.text = invoiceItem?.unit_price.description

        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else {
            return true
        }
        
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return replacementText.isDecimal()
    }
    

    @IBAction func save(_ sender: Any) {
     //   let client_id = client?.client_id ?? nil
       // var endPoint: String
//        var quantity: Decimal
//        var unitPrice: Decimal
//        var description: String
        
        let quantity = quantityTextField.text ?? ""
        let unitPrice = unitPriceTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        let result = Decimal(string: unitPrice)
        let result2 = Decimal(string: quantity)
        
        
        let alert = UIAlertController(title: "Success!", message: "Invoice Saved!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.performSegue(withIdentifier: "unwindToInvoice", sender: self)
        })

        alert.addAction(OKAction)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)

        })
        
        
        
        
//        if (invoice?.invoice_id) != nil {
//            endPoint = "api/invoices/update"
//        } else {
//            endPoint = "api/invoices/add"
//        }
        

        invoiceItem = InvoiceItem(invoice_detail_id: invoiceItem?.invoice_detail_id, description: description, unit_price: result!, quantity: result2!)
        
//
//
//        let requestBody = makeJSONData(invoiceItem)
//
//        makeRequestPost(endpoint: endPoint,
//                        requestType: "POST",
//                        requestBody: requestBody,
//                        view: view,
//                        completionHandler: { (response : ApiContainer<Invoice>?, error : Error?) in
//                            if let error = error {
//                                print("error calling POST on /todos")
//                                print(error)
//                                return
//                            }
//                            let responseMeta = (response?.meta)!
//                            let responseData = (response?.result[0])
//                            let invoice_id = responseData?.invoice_id
//                            self.invoice?.invoice_id = invoice_id
//
//                            if(responseMeta.sucess == "yes") {
//                                let alert = UIAlertController(title: "Success!", message: "Invoice Saved!", preferredStyle: .alert)
//                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                                    (_)in
//                                    self.performSegue(withIdentifier: "unwindToInvoices", sender: self)
//                                })
//
//                                alert.addAction(OKAction)
//                                DispatchQueue.main.async(execute: {
//                                    self.present(alert, animated: true, completion: nil)
//
//                                })
//                            }
//                            else
//                            {
//                                DispatchQueue.main.async(execute: {
//                                    let myAlert = UIAlertController(title: "Error", message: "Error creating Invoice", preferredStyle: .alert)
//                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                                    myAlert.addAction(okAction)
//                                    self.present(myAlert, animated: true, completion: nil)
//                                })
//                                return
//                            }
//        } )
    }
    


}
