
import UIKit
import WebKit


//https://medium.com/@sourleangchhean/ios-customized-activity-indicator-with-swift-3-0-2-f26f7dd6a064

class ViewController: UIViewController {
    
    @IBOutlet weak var login_email: UITextField!
    @IBOutlet weak var login_password: UITextField!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = DAKeychain.shared["email"]
        login_email.text = value
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    @IBAction func btnLog2(_ sender: Any) {
        
        let user = User(email: login_email.text!, password : login_password.text!)
        
        var jsonData = Data()
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(user)
        }
        catch {
        }
        
        makeRequestPost(endpoint: "api/login",
                        requestType: "POST",
                        requestBody: jsonData,
                        view: view,
                        completionHandler: { (response : ApiContainer<Response>?, error : Error?) in
                            if let error = error {
                                print("error calling POST on /todos")
                                print(error)
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
                                DispatchQueue.main.async(execute: {
                                    let myAlert = UIAlertController(title: "Error", message: "Invalid E-mail or Password", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                            }
        } )
        
    }
}

