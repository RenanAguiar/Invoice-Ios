//
//  UserViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-31.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    @IBOutlet weak var businessNameValidationLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var passwordConfirmationValidationLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var validationLabel: [UILabel]!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func create(_ sender: Any) {
        
        clearValidationLabels()
        
        

        
        let itemsToValidade = [
            formValidation(textField: businessNameTextField, label: businessNameValidationLabel),
            formValidation(textField: emailTextField, label: emailValidationLabel),
            formValidation(textField: passwordTextField, label: passwordValidationLabel),
            formValidation(textField: passwordConfirmationTextField, label: passwordConfirmationValidationLabel)
        ]

        
        if(!checkValidation(itemsToValidade)) {
            self.showAlert(title: "Error", message: "Check error.")
            return
        }
        
        
        
        let signUp = SignUp(businessName: businessNameTextField.text!,
                            email : emailTextField.text!,
                            password: passwordTextField.text!,
                            passwordConfirmation : passwordConfirmationTextField.text!)
        
         let requestBody = makeJSONData(signUp)
        
        makeRequestPost(endpoint: "api/sign_up",
                        requestType: "POST",
                        requestBody: requestBody,
                        view: view,
                        completionHandler: { (response : ApiContainer<Login>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                return
                            }
                            
                            let a = (response?.result)!
                            let b = (response?.meta)!
                            print(b)
                            print(a[0])
                            if(b.sucess == "yes") {
                                
                                //DAKeychain.shared["email"] = (user.email) // Store
                                DAKeychain.shared["token"] = (a[0].token) // Store
                                DispatchQueue.main.async(execute: {
                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarClients") as UIViewController
                                    self.present(viewController, animated: false, completion: nil)
                                })
                                print("created")
                            }
                            else
                            {
                                DispatchQueue.main.async(execute: {
                                    let myAlert = UIAlertController(title: "Error", message: "Error creating user", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                            }
        } )
        
    }
    
    

    
    func checkValidation(_ fields:[formValidation]) -> Bool {
        
        var hasError = false
        for field in fields {
            let (valid, message) = validate(field.textField)
            
            if !valid {
                field.label.text = message
                field.label.isHidden = valid
                hasError = true
            }
           
        }
        

        return !hasError
    }
    
    

    

    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        if textField == businessNameTextField {
            return (text.count >= 3, "Business Name is at least 3 characteres.")
        }
        
        if textField == emailTextField {
            return (text.count >= 3, "E-mail is at least 3 characteres.")
        }
        
        return (text.count > 0, "This field cannot be empty.")
    }
    
    func clearValidationLabels() {
        
        for label in self.validationLabel {
            label.text = ""
            label.isHidden = true
        }
        

    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        clearValidationLabels()
        
        for label in self.validationLabel {
           label.textColor = UIColor.red
        }
      
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}