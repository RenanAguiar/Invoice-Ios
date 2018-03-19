//
//  ProfileViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-29.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, AccessoryToolbarDelegate {
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
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        provinceTextField.inputView = thePicker
        thePicker.delegate = self
        setUpTextFieldPicker(textField: provinceTextField)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProfile()
        selectPickerViewRow()
        
    }
    
    
    
    @IBAction func btnLogout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let province = selectedProvince ?? ""
        let postalCode = postalCodeTextField.text ?? ""
        let unitPrice = taxTextField.text ?? ""
        let tax = Decimal(string: unitPrice)
        let endPoint: String = "profile/update"
        
        self.view.endEditing(true)
        
        profile = Profile(name: name, phone: phone, postal_code: postalCode, province: province, city: city, address: address, tax: tax!)
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
                            
                            if(responseMeta.sucess == "yes") {
                                let alert = UIAlertController(title: "Success!", message: "Profile Updated!", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_)in })
                                
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
    
}

// MARK: - Picker View
extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

// MARK: - Text Field
class TextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [Any] {
        return []
    }
    
    //disable copy/paste/cursor
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

// MARK: - Control Functions
extension ProfileViewController {
    
    func selectPickerViewRow() {
        selectedProvince = profile?.province
        if let province = selectedProvince,
            let index = provinces.index(where: { $0.abbrev == province }) {
            thePicker.selectRow(index, inComponent: 0, animated: false)
            provinceTextField.text = provinces[index].abbrev
        }
    }
    
    func getProfile() {
        makeRequest(endpoint: "profile/get",
                    parameters: [:],
                    completionHandler: { (container : ApiContainer<Profile>?, error : Error?) in
                        if let error = error {
                            print("error calling POST on /getProfile")
                            print(error)
                            return
                        }
                        self.profile = container?.result[0]
                        DispatchQueue.main.async(execute: {
                            self.nameTextField.text = self.profile?.name
                            self.cityTextField.text = self.profile?.city
                            self.postalCodeTextField.text = self.profile?.postal_code
                            self.addressTextField.text = self.profile?.address
                            self.phoneTextField.text = self.profile?.phone
                            self.taxTextField.text = self.profile?.tax.description
                            self.selectPickerViewRow()
                            DAKeychain.shared["tax"] = (self.profile?.tax.description)
                        })
                        
        } )
    }
}
