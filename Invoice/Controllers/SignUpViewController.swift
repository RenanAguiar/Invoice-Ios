import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var validationLabel: [UILabel]!
    
    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: - View
    
    // MARK: - Testing - possibility to scroll the view when in text field
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let y = 100
        let x = 0
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let y = 0
        let x = 0
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordConfirmationTextField.delegate = self
        
        clearValidationLabels()
        for label in self.validationLabel {
            label.textColor = UIColor.red
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func create(_ sender: Any) {
        clearValidationLabels()
        let itemsToValidade = [
            formValidation(textField: businessNameTextField, label: validationLabel[0]),
            formValidation(textField: emailTextField, label: validationLabel[1]),
            formValidation(textField: passwordTextField, label: validationLabel[2]),
            formValidation(textField: passwordConfirmationTextField, label: validationLabel[3])
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
        
        makeRequestPost(endpoint: "sign_up",
                        requestType: "POST",
                        requestBody: requestBody,
                        view: view,
                        completionHandler: { (response : ApiContainer<Login>?, error : Error?) in
                            if let error = error {
                                print(error)
                                self.showAlert(title: "Error", message: "Server error.")
                                return
                            }
                            
                            let result = (response?.result)!
                            let meta = (response?.meta)!
                            if(meta.sucess == "yes") {
                                DAKeychain.shared["token"] = (result[0].token) // Store
                                DispatchQueue.main.async(execute: {
                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarClients") as UIViewController
                                    self.present(viewController, animated: true, completion: nil)
                                })
                                print("created")
                            }
                            else
                            {
                                self.showAlert(title: "Error", message: "Error creating user.")
                            }
        } )
        
    }
    
    
    // MARK: - Validation
    
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
    
    func validate(_ textField: UITextField) -> (Bool, String?) {
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
}

