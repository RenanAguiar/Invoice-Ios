//
//  ProfileViewController.swift
//  tes
//
//  Created by Renan Aguiar on 2017-12-29.
//  Copyright © 2017 Renan Aguiar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



    
    @IBAction func btnLogout(_ sender: Any) {
        
        //https://medium.com/@paul.allies/ios-swift4-login-logout-branching-4cdbc1f51e2c
        

var rootVC : UIViewController?
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewLogin") as! ViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC

        
    }
    
    
    
    
    
    @IBAction func btnRead(_ sender: Any) {
        let value = DAKeychain.shared["token"] // Fetch
        print(value!)
    }
    
    
    
    @IBAction func btnStore(_ sender: Any) {
        DAKeychain.shared["token"] = "confidential data" // Store
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    


}
