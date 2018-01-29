
import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let email = DAKeychain.shared["email"]
        emailTextField.text = email
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   

    
    @IBAction func doLogin(_ sender: Any) {
        
        let user = User(email: emailTextField.text!, password : passwordTextField.text!)
        let requestBody = makeJSONData(user)
        
        makeRequestPost(endpoint: "api/login",
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
                            let responseData = (response?.result[0])!
                            
                            
                            if(responseMeta.sucess == "yes") {
                                DAKeychain.shared["email"] = (user.email)
                                DAKeychain.shared["token"] = (responseData.message)
                                DispatchQueue.main.async(execute: {
                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarClients") as UIViewController
                                    self.present(viewController, animated: true, completion: nil)
                                })
                            }
                            else
                            {
                                self.showAlert(title: "Error", message: "Invalid E-mail or Password")
                            }
        } )
        
    }
}

