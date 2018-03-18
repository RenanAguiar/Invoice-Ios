
import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    func setupTextFields() {
        
//        let svFrame = CGRect(x: 0, y: 0, width: 40, height: emailTextField.bounds.height/2)
//        let usernameUserIconView = SidesView.init(frame: svFrame)
//        usernameUserIconView.icon = #imageLiteral(resourceName: "email")
//        emailTextField.leftView = usernameUserIconView
//        emailTextField.leftViewMode = .always
        

//        let svFrame2 = CGRect(x: 0, y: 0, width: 40, height: passwordTextField.bounds.height/2)
//        let passwordIconView = SidesView.init(frame: svFrame2)
//        passwordIconView.icon = #imageLiteral(resourceName: "password")
//        passwordTextField.leftView = passwordIconView
//        passwordTextField.leftViewMode = .always
        
        addImageToTextField(textField: emailTextField, icon: #imageLiteral(resourceName: "email"))
        addImageToTextField(textField: passwordTextField, icon: #imageLiteral(resourceName: "password"))
        
    }
    
    func addImageToTextField(textField: UITextField, icon: UIImage) {
        let svFrame = CGRect(x: 0, y: 0, width: 40, height: textField.bounds.height/2)
        let image = SidesView.init(frame: svFrame)
        image.icon = icon
        textField.leftView = image
        textField.leftViewMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let email = DAKeychain.shared["email"]
        emailTextField.text = email
    }    
    
}


// MARK: - Text Field Delegate
extension LoginViewController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
            doLogin(nil)
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}


extension LoginViewController {
    
    @IBAction func doLogin(_ sender: Any?) {
        let user = User(email: emailTextField.text!, password : passwordTextField.text!)
        let requestBody = makeJSONData(user)
        self.view.endEditing(true)
        
        makeRequestPost(endpoint: "login",
                        requestType: "POST",
                        requestBody: requestBody,
                        view: view,
                        completionHandler: { (response : ApiContainer<Response>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
                                self.showAlert(title: "Server Error", message: "Please, try again!")
                                return
                            }
                            
                            let responseMeta = (response?.meta)!
                            let responseDataToken = (response?.result[0])!
                            let responseDataTax = (response?.result[1])!
                            if(responseMeta.sucess == "yes") {
                                DAKeychain.shared["email"] = (user.email)
                                DAKeychain.shared["token"] = (responseDataToken.message)
                                DAKeychain.shared["tax"] = (responseDataTax.message)
                                DispatchQueue.main.async(execute: {
                                    self.passwordTextField.text = ""
                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarClients") as UIViewController
                                    self.present(viewController, animated: true, completion: nil)
                                })
                            }
                            else
                            {
                                self.showAlert(title: "Error", message: "Invalid E-mail or Password")
                                return
                            }
        } )
        
    }
    
}

