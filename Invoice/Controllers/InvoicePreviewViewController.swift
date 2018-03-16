//
//  InvoicePreviewViewController.swift
//  Invoice
//
//  Created by Renan Aguiar on 2018-03-15.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import UIKit
import WebKit

class InvoicePreviewViewController: UIViewController {

    @IBOutlet weak var preview: WKWebView!
    var invoice: Invoice?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(invoice!)
        let invoiceId : String! = "\(invoice!.invoice_id!)"
        let endpoint = "api/invoices/"+invoiceId+"/download"
        // let endpoint = URL(string: "api/invoices/"+invoiceId+"/download")
        let fullEndPoint = baseEndPoint + endpoint
        
        let url = URL(string: fullEndPoint)
        // let url = URL(string: "api/invoices/"+invoiceId+"/download")
        
        if let unwrappedURL = url {
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async {
                       
                        self.preview.load(request)
                    }
                } else {
                    print("no")
                }
            }
            task.resume()
        }
    }

}
