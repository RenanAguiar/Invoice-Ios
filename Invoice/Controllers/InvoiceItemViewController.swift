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
         if (invoice?.invoice_id) != nil {
        self.navigationItem.rightBarButtonItem?.title = "Save"
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
    

    func saveOnServer(invoiceItem: InvoiceItem) {
        var endPoint: String
        if (invoiceItem.invoice_detail_id) != nil {
            endPoint = "api/invoices/update/item"
        } else {
            endPoint = "api/invoices/add/item"
        }

        let requestBody = makeJSONData(invoiceItem)
        print(endPoint)
        makeRequestPost(endpoint: endPoint,
                        requestType: "POST",
                        requestBody: requestBody,
                        view: view,
                        completionHandler: { (response : ApiContainer<InvoiceItem>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                return
                            }
                            let responseMeta = (response?.meta)!

                            
                            if(responseMeta.sucess == "yes") {
                                let responseData = (response?.result[0])
                                let invoice_detail_id = responseData?.invoice_detail_id
                                self.invoiceItem?.invoice_detail_id = invoice_detail_id
                                let alert = UIAlertController(title: "Success!", message: "Invoice Item Saved!", preferredStyle: .alert)
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
                                    let myAlert = UIAlertController(title: "Error", message: "Error creating Item", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                                return
                            }
        } )
    }
    @IBAction func save(_ sender: Any) {

        
        let quantity = quantityTextField.text ?? ""
        let unitPrice = unitPriceTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        let result = Decimal(string: unitPrice)
        let result2 = Decimal(string: quantity)

        invoiceItem = InvoiceItem(invoice_detail_id: invoiceItem?.invoice_detail_id, invoice_id: invoice?.invoice_id, description: description, unit_price: result!, quantity: result2!)


        if (invoice?.invoice_id) != nil {
            saveOnServer(invoiceItem: invoiceItem!)
        return
        }
        
        
        
        
        
        
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
   
    
    
    @IBAction func deleteItemConfirm(_ sender: Any) {
        showDeleteAlert()
    }
    
    func showDeleteAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete Item", style: .destructive, handler: { (action) -> Void in
            self.deleteItem()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func deleteItem() {
        let invoice_detail_id : String! = "\(invoiceItem!.invoice_detail_id!)"
        var endPoint: String
        endPoint = "api/invoices/items/"+invoice_detail_id+"/delete"
        print(endPoint)
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
                    let alert = UIAlertController(title: "Success!", message: "Item Deleted.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (_)in
                        self.performSegue(withIdentifier: "unwindToInvoice", sender: self)
                    })
                    alert.addAction(OKAction)
                    
                    DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true, completion: nil)
                    })
                    
        }  )
        
    }


}
