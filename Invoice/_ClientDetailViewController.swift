//
//  ClientDetailViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-13.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import UIKit

class ClientDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   

   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return arrProvinceName.count
        return provinces.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       // return arrProvinceName[row]
        return provinces[row].name
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      //  self.view.endEditing(true)
       // txtProvince.text = arrProvinceAbbr[row]
        txtProvince.text = provinces[row].abbrev
    }
    
    
    var meal: Client?
   var client = Client(name:"", client_id: nil, postal_code: "", province: "", city: "", address: "")
    //
    //
    override func viewWillAppear(_ animated: Bool) {
        if (client.client_id) != nil {
            self.title = "Edit"
            txtName.text = client.name
            txtCity.text = client.city
            txtAddress.text = client.address
            txtProvince.text = client.province
            txtPostalCode.text = client.postal_code
        }
        else {
            self.title = "New"
        }

    }

    
    @IBAction func btnVai(_ sender: Any) {
//        let name = txtName.text ?? ""
//        let address = txtAddress.text ?? ""
//        let city = txtCity.text ?? ""
//        let province = txtProvince.text ?? ""
//        let postal_code = txtPostalCode.text ?? ""
//        var endPoint: String
//
//        if (client.client_id) != nil {
//            endPoint = "http://blog.local:4711/api/clients/update"
//        } else {
//            endPoint = "http://blog.local:4711/api/clients/add"
//        }
//
//        meal = Client(name:name, client_id: client.client_id, postal_code: postal_code, province: province, city: city, address: address)
//        var jsonData = Data()
//        let jsonEncoder = JSONEncoder()
//        do {
//            jsonData = try jsonEncoder.encode(meal)
//        }
//        catch {
//        }
//
//
//        makeRequestPost(endpoint: endPoint,
//                        requestType: "POST",
//                        requestBody: jsonData,
//                        view: view,
//                        completionHandler: { (response : ApiContainer<Client>?, error : Error?) in
//                            if let error = error {
//                                print("error calling POST on /todos")
//                                print(error)
//                                return
//                            }
//                            let b = (response?.meta)!
//                            print(b.sucess)
//                            let a = (response?.result[0])
//                            let client_id = a?.client_id
//                            self.meal?.client_id = client_id
//
//                            if(b.sucess == "yes") {
//
//
//                                let alert = UIAlertController(title: "Order Placed!", message: "Thank you for your order.\nWe'll ship it to you soon!", preferredStyle: .alert)
//                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
//                                    (_)in
//                                    self.performSegue(withIdentifier: "unwindToClients", sender: self)
//                                })
//
//                                alert.addAction(OKAction)
//                                     DispatchQueue.main.async(execute: {
//                                self.present(alert, animated: true, completion: nil)
//
//                                })
//
//
//                            }
//                            else
//                            {
//                                DispatchQueue.main.async(execute: {
//                                    let myAlert = UIAlertController(title: "Error", message: "Error creating Client", preferredStyle: .alert)
//                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                                    myAlert.addAction(okAction)
//                                    self.present(myAlert, animated: true, completion: nil)
//                                })
//                                return
//                            }
//        } )
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        let name = txtName.text ?? ""
        let address = txtAddress.text ?? ""
        let city = txtCity.text ?? ""
        let province = txtProvince.text ?? ""
        let postal_code = txtPostalCode.text ?? ""
        var endPoint: String
        
        if (client.client_id) != nil {
            endPoint = "api/clients/update"
        } else {
            endPoint = "api/clients/add"
        }
        
        meal = Client(name:name, client_id: client.client_id, postal_code: postal_code, province: province, city: city, address: address)
        var jsonData = Data()
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(meal)
        }
        catch {
        }
        
        
        makeRequestPost(endpoint: endPoint,
                        requestType: "POST",
                        requestBody: jsonData,
                        view: view,
                        completionHandler: { (response : ApiContainer<Client>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                return
                            }
                            let b = (response?.meta)!
                            print(b.sucess)
                            let a = (response?.result[0])
                            let client_id = a?.client_id
                            self.meal?.client_id = client_id
                            
                            if(b.sucess == "yes") {
                                
                                
                                let alert = UIAlertController(title: "Success!", message: "Thank you for your order.\nWe'll ship it to you soon!", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                    (_)in
                                    self.performSegue(withIdentifier: "unwindToClients", sender: self)
                                })
                                
                                alert.addAction(OKAction)
                                DispatchQueue.main.async(execute: {
                                    self.present(alert, animated: true, completion: nil)
                                    
                                })
                                
                                
                            }
                            else
                            {
                                DispatchQueue.main.async(execute: {
                                    let myAlert = UIAlertController(title: "Error", message: "Error creating Client", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                                return
                            }
        } )
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)        
        guard let button = sender as? UIBarButtonItem, button === btnSave else {
            return
        }
    }
    
    
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!    
    @IBOutlet weak var txtProvince: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thePicker = UIPickerView()
        txtProvince.inputView = thePicker
        thePicker.delegate = self
        
        
        
        
        
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ClientDetailViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ClientDetailViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtProvince.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick() {
        txtProvince.resignFirstResponder()
    }
    @objc func cancelClick() {
        txtProvince.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
