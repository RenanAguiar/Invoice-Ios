//
//  ProfileViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-29.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var selectedProvince: String?
    var thePicker = UIPickerView()
    var profile: Profile?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    
    
    @IBAction func saveProfile(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let city = cityTextField.text ?? ""
       // let province = provinceTextField.text ?? ""
        let province = selectedProvince ?? ""
        let postalCode = postalCodeTextField.text ?? ""
      //  let tax = taxTextField.text ?? ""
        
        let unitPrice = taxTextField.text ?? ""
      
        
        let tax = Decimal(string: unitPrice)
        
        
       // let client_id = client?.client_id ?? nil
        let endPoint: String = "api/profile/update"
   
        
        profile = Profile(name: name, phone: phone, postal_code: postalCode, province: province, city: city, address: address, tax: tax!)
       

     self.view.endEditing(true)
        
        
        
        let requestBody = makeJSONData(profile)
        
        makeRequestPost(endpoint: endPoint,
                        requestType: "POST",
                        requestBody: requestBody,
                        view: view,
                        completionHandler: { (response : ApiContainer<Response>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                return
                            }
                            let responseMeta = (response?.meta)!
                          //  let responseData = (response?.result[0])
                          //  let client_contact_id = responseData?.client_contact_id
                           // self.contact?.client_contact_id = client_contact_id
                            
                            if(responseMeta.sucess == "yes") {
                                let alert = UIAlertController(title: "Success!", message: "Profile Updated!", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                    (_)in
                                    //self.performSegue(withIdentifier: "unwindToContacts", sender: self)
                                })
                                
                                alert.addAction(OKAction)
                                DispatchQueue.main.async(execute: {
                                    self.present(alert, animated: true, completion: nil)
                                    
                                })
                            }
                            else
                            {
                                DispatchQueue.main.async(execute: {
                                    let myAlert = UIAlertController(title: "Error", message: "Error creating Contact", preferredStyle: .alert)
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.getProfile()
        selectPickerViewRow()
   
    }
    @IBAction func btnLogout(_ sender: Any) {
//        var rootVC : UIViewController?
//        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewLogin") as! LoginViewController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = rootVC
self.dismiss(animated: true, completion: nil)
    }
    
    
    func selectPickerViewRow() {
        selectedProvince = profile?.province
        if let province = selectedProvince,
            let index = provinces.index(where: { $0.abbrev == province }) {
            thePicker.selectRow(index, inComponent: 0, animated: false)
            provinceTextField.text = provinces[index].name
        }
    }
    
}


extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    @objc func doneClick() {
        provinceTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        selectPickerViewRow()
        provinceTextField.resignFirstResponder()
    }
    
    
    
    
    
    
    
    
    
    
    
}
extension ProfileViewController {
    
    func getProfile() {
        //let client_id : String! = "\(client!.client_id!)"
        makeRequest(endpoint: "api/profile/get",
                    parameters: [:],
                    completionHandler: { (container : ApiContainer<Profile>?, error : Error?) in
                        if let error = error {
                            print("error calling POST on /getProfile")
                            print(error)
                            return
                        }
                       // print(container!)
                        self.profile = container?.result[0]
                        DispatchQueue.main.async(execute: {
                        self.nameTextField.text = self.profile?.name
                            self.cityTextField.text = self.profile?.city
                            self.postalCodeTextField.text = self.profile?.postal_code
                            self.addressTextField.text = self.profile?.address
                           // self.provinceTextField.text = self.profile?.province
                            self.phoneTextField.text = self.profile?.phone
                            self.taxTextField.text = self.profile?.tax.description
                            self.selectPickerViewRow()
                        })

        } )
    }
}

//disable copy/paste/cursor
class TextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
    return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [Any] {
    return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
    if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
    
    return false
    }
    
    return super.canPerformAction(action, withSender: sender)
    }
}
