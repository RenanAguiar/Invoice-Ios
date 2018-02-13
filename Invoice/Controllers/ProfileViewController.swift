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
    }
       
    @IBAction func btnLogout(_ sender: Any) {
        var rootVC : UIViewController?
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewLogin") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
    
}
