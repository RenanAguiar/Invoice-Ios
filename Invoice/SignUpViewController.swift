//
//  UserViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-31.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirmation: UITextField!
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnCreate(_ sender: Any) {
        
        
        let signUp = SignUp(businessName: txtBusinessName.text!,
                            email : txtEmail.text!,
                            password: txtPassword.text!,
                            passwordConfirmation : txtPasswordConfirmation.text!)
        
        var jsonData = Data()
        
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(signUp)
        }
        catch {
            
        }
        
        
        
        makeRequestPost(endpoint: "api/sign_up",
                        requestType: "POST",
                        requestBody: jsonData,
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
