//
//  
//  tes
//
//  Created by Renan Aguiar on 2018-01-16.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import UIKit

class ClientViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var contactsLabel: UILabel!
    
    var thePicker = UIPickerView()
    let numberOfRowsAtSection: [Int] = [4, 2]
    
    var client: Client?
    var selectedProvince: String?
    var wasDeleted: Bool? = false
    
    
    @IBAction func deleteClientConfirm(_ sender: Any) {
        showDelete()
    }
    
    
    func deleteClient() {
        
        let client_id : String! = "\(client!.client_id!)"
        var endPoint: String
        
        endPoint = "api/clients/"+client_id+"/delete"
        
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
                       // message = error.localizeDescription
                        message = "ERROR"
                    }
                    self.showAlert(title: "Error", message: message)
                    return
                }
                self.wasDeleted = true

                //change message and use the custom func like on error.
                let alert = UIAlertController(title: "Success!", message: "Client Deleted.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (_)in
                    self.performSegue(withIdentifier: "unwindToClients", sender: self)
                })
                alert.addAction(OKAction)
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })
                
                }  )
        
    }
    
    func showDelete() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let  deleteButton = UIAlertAction(title: "Delete Client", style: .destructive, handler: { (action) -> Void in
            print("Delete button tapped")
            self.deleteClient()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "New"
        if (client?.client_id) != nil {
            self.title = "Edit"
            nameTextField.text = client?.name
            cityTextField.text = client?.city
            addressTextField.text = client?.address
            postalCodeTextField.text = client?.postal_code
            
            selectPickerViewRow()

            
            
        }
    }
    
    func selectPickerViewRow() {
        selectedProvince = client?.province
        if let province = selectedProvince,
            let index = provinces.index(where: { $0.abbrev == province }) {
            thePicker.selectRow(index, inComponent: 0, animated: false)
            provinceTextField.text = provinces[index].name
        }
    }
    
    @objc func save(sender: UIButton!) {
        let name = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let province = selectedProvince ?? ""
        let postal_code = postalCodeTextField.text ?? ""
        var endPoint: String
       
        
        if (client?.client_id) != nil {
            endPoint = "api/clients/update"
        } else {
            endPoint = "api/clients/add"
        }
        
        client = Client(name:name, client_id: client?.client_id, postal_code: postal_code, province: province, city: city, address: address)
        

        let requestBody = makeJSONData(client)
        
        makeRequestPost(endpoint: endPoint,
                        requestType: "POST",
                        requestBody: requestBody,
                        view: view,
                        completionHandler: { (response : ApiContainer<Client>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                return
                            }
                            let b = (response?.meta)!
                            let a = (response?.result[0])
                            let client_id = a?.client_id
                            self.client?.client_id = client_id
                            
                            if(b.sucess == "yes") {
                                
                                //change message and use the custom func like on error.
                                let alert = UIAlertController(title: "Success!", message: "All good", preferredStyle: .alert)
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
                                self.showAlert(title: "Error", message: "Error Creating Client")
                                //return
                            }
        } )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderHeight = 50.0;
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        
        provinceTextField.inputView = thePicker
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
        provinceTextField.inputAccessoryView = toolBar

    }
    
    @objc func doneClick() {
        provinceTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        selectPickerViewRow()
        provinceTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        if  segue.identifier == "unwindToClients",
            let destination = segue.destination as? ClientsViewController
        {
            destination.client = client
        }
        
        if  segue.identifier == "showContacts",
            let destination = segue.destination as? ContactsViewController
        {
            destination.client = client
        }
        
    }

    
    // MARK: - Picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return provinces.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return provinces[row].name
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        provinceTextField.text = provinces[row].name
        selectedProvince = provinces[row].abbrev
    }
    
    
    
    
}
