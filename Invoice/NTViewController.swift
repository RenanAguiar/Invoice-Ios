//
//  NTViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2018-01-16.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import UIKit

class NTViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtProvince: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var lblContacts: UILabel!
    
    let numberOfRowsAtSection: [Int] = [4, 2]
    
    var meal: Contact?
    var meal2: Client?
    var client = Client(name:"", client_id: nil, postal_code: "", province: "", city: "", address: "")
    var selectedProvince: String?
    
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
        txtProvince.text = provinces[row].name
        //txtProvince.text = provinces[row].abbrev
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (client.client_id) != nil {
            self.title = "Edit"
            txtName.text = client.name
            txtProvince.text = client.province
            txtCity.text = client.city
            txtAddress.text = client.address
            txtPostalCode.text = client.postal_code
            selectedProvince = client.province
            
        }
        else {
            self.title = "New"
        }
        print("hh")
    }
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
    
    
    @objc func save(sender: UIButton!) {
        let name = txtName.text ?? ""
        let address = txtAddress.text ?? ""
        let city = txtCity.text ?? ""
     //   let province = txtProvince.text ?? ""
        let province = selectedProvince ?? ""
        let postal_code = txtPostalCode.text ?? ""
        var endPoint: String
        
        if (client.client_id) != nil {
            endPoint = "api/clients/update"
        } else {
            endPoint = "api/clients/add"
        }
        
        meal2 = Client(name:name, client_id: client.client_id, postal_code: postal_code, province: province, city: city, address: address)
        var jsonData = Data()
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(meal2)
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
                                
                                
                                let alert = UIAlertController(title: "Order Placed!", message: "Thank you for your order.\nWe'll ship it to you soon!", preferredStyle: .alert)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
tableView.sectionHeaderHeight = 50.0;
        
              navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        
        
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
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       // return 5
        
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Client"
        navigationItem.backBarButtonItem = backItem
        
        
        if  segue.identifier == "unwindToClients" {
            print("trem bao")
        }
        
        
        
        if  segue.identifier == "showContacts",
            let destination = segue.destination as? ContactsViewController
        {
            
            print("rosa")
            print(client)
            print("rosa")
            destination.client = client

        }
        
    }
    
    

}
