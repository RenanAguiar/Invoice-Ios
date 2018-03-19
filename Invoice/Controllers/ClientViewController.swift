
import UIKit

class ClientViewController: UITableViewController, AccessoryToolbarDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var contactsLabel: UILabel!
    
    @IBOutlet weak var deleteClientConfirmOutlet: UIButton!
    
    var thePicker = UIPickerView()
    let numberOfRowsAtSection: [Int] = [4, 2]
    var numberOfSections: Int = 2
    
    var client: Client?
    var selectedProvince: String?
    var wasDeleted: Bool? = false
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionHeaderHeight = 50.0;
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveClient))
        
        provinceTextField.inputView = thePicker
        thePicker.delegate = self
        setUpTextFieldPicker(textField: provinceTextField)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (client?.client_id) != nil {
            numberOfSections = 2
            self.title = "Edit"
            nameTextField.text = client?.name
            cityTextField.text = client?.city
            addressTextField.text = client?.address
            postalCodeTextField.text = client?.postal_code
            selectPickerViewRow()
            deleteClientConfirmOutlet.isHidden = false
        } else {
            self.title = "New"
            numberOfSections = 1
            deleteClientConfirmOutlet.isHidden = true
            
        }
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
        
        if  segue.identifier == "showInvoices",
            let destination = segue.destination as? InvoicesViewController
        {
            destination.client = client
        }
        
    }
    
    
    @IBAction func deleteClientConfirm(_ sender: Any) {
        showDeleteAlert()
    }
    
    // MARK: - ToolBar Action
    func doneClicked(for textField: UITextField) {
        provinceTextField.resignFirstResponder()
    }
    
    func cancelClicked(for textField: UITextField) {
        selectPickerViewRow()
        provinceTextField.resignFirstResponder()
    }
    
    // MARK: - REDO ==> same as in invoice
    func setUpTextFieldPicker(textField: UITextField) {
        textField.inputView = thePicker
        let toolbar = AccessoryToolbar(for: textField)
        toolbar.accessoryDelegate = self
    }
    
    
    

    
    @objc func saveClient(sender: UIButton!) {
        let name = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let province = selectedProvince ?? ""
        let postal_code = postalCodeTextField.text ?? ""
        var endPoint: String
        
        
        if (client?.client_id) != nil {
            endPoint = "clients/update"
        } else {
            endPoint = "clients/add"
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
                            let responseMeta = (response?.meta)!
                            let responseData = (response?.result[0])
                            let client_id = responseData?.client_id
                            self.client?.client_id = client_id
                            
                            if(responseMeta.sucess == "yes") {
                                
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
    
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        return rows
    }
    
    
}

// MARK: - Picker view
extension ClientViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        provinceTextField.text = provinces[row].abbrev
        selectedProvince = provinces[row].abbrev
    }
}

// MARK: - Control Functions
extension ClientViewController {
    
    func showDeleteAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let  deleteButton = UIAlertAction(title: "Delete Client", style: .destructive, handler: { (action) -> Void in
            self.deleteClient()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func deleteClient() {
        let client_id : String! = "\(client!.client_id!)"
        var endPoint: String
        endPoint = "clients/"+client_id+"/delete"
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
    
    func selectPickerViewRow() {
        selectedProvince = client?.province
        if let province = selectedProvince,
            let index = provinces.index(where: { $0.abbrev == province }) {
            thePicker.selectRow(index, inComponent: 0, animated: false)
            provinceTextField.text = provinces[index].abbrev
        }
    }
}
