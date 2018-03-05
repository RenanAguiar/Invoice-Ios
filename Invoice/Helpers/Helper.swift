
import Foundation
import UIKit



extension String{
    func isDecimal()->Bool{
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.locale = Locale.current
        return formatter.number(from: self) != nil
    }
}


/**
 It converts a struct to JSON Data
 
 This method accepts a struct and converts it to JSON Data.
 
 :param: value The struct.
 
 :returns:   Data JSON data.
 */
func  makeJSONData<T: Codable>(_ value: T) -> Data {
    var jsonData = Data()
    let jsonEncoder = JSONEncoder()
    
    do {
        jsonData = try jsonEncoder.encode(value)
    }
    catch {
    }
    return jsonData
}

extension UIViewController {
    /**
     It shows an Alert
     
     This method accepts a title and a message.
     
     :param: title The title.
     
     :param: message The message.

     */
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
            self.present(alertController, animated: true, completion: nil)
    }
    }
    
}


extension UIViewController {
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

let baseEndPoint = "https://rca.pro.br/"
//let baseEndPoint = "http://blog.local:4711/"

func makeRequest<T>(httpMethod: String = "GET",
                    endpoint: String,
                    parameters: [String: String?],
                    completionHandler: @escaping (ApiContainer<T>?, Error?) -> ()) {
   
    let token = DAKeychain.shared["token"]
    let fullEndPoint = baseEndPoint + endpoint
    
    guard var urlComponents = URLComponents(string: fullEndPoint) else {
        print("Invalid endpoint")
        return
    }
    
    // Build an array containing the parameters the user specified
    var queryItems = parameters.map { key, value in URLQueryItem(name: key, value: value) }
    
    // Optional: Add default values for parameters that the user missed
    if !queryItems.contains(where: { $0.name == "token" }) {
        queryItems.append(URLQueryItem(name: "token", value: token))
    }
    
    // Add these parameters to the URLComponents
    urlComponents.queryItems = queryItems
    
    // And here's your final URL
    guard let url = urlComponents.url else {
        print("Cannot construct URL")
        return
    }
    print(url)
    var urlRequest = URLRequest(url: url)
    let session = URLSession.shared
    
  //  urlRequest.httpMethod = "GET"
    urlRequest.httpMethod = httpMethod
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    

    let task = session.dataTask(with: urlRequest, completionHandler: {
        (data, response, error) in
        guard let responseData = data else {
            print("Error: did not receive data")
            completionHandler(nil, error)
            return
        }
        guard error == nil else {
            completionHandler(nil, error!)
            return
        }
        
        if(httpMethod == "GET") {
        do {
            let response = try JSONDecoder().decode(ApiContainer<T>.self, from: responseData)
            completionHandler(response, nil)
        }
        catch {
            print("error trying to convert data to JSON2")
            print(error)
            completionHandler(nil, error)
            }}
        else {
            if let httpResponse = response as? HTTPURLResponse{
                print(httpResponse.statusCode)
              //  print(httpResponse)
                if httpResponse.statusCode == 200{
                    print("deleted")
                    return
                }
                else if (httpResponse.statusCode == 404) {
                    print("not found")
                    return
                }
                else {
                    print("something made an error")
                    return
                }
            }
        }
        
        
        
    })
    task.resume()
}



func makeRequestPost<T>(endpoint: String,
                        requestType: String = "POST",
                        requestBody: Data,
                        view: UIView,
                        completionHandler: @escaping (ApiContainer<T>?, Error?) -> ()) {
    
    let fullEndPoint = baseEndPoint + endpoint
    let token = DAKeychain.shared["token"]
    


    ViewControllerUtils().showActivityIndicator(uiView: view)

    guard let url = URL(string: fullEndPoint) else {
        let error = BackendError.urlError(reason: "Could not create URL")
        completionHandler(nil, error)
        return
    }
    
    var urlRequest = URLRequest(url: url)
    let session = URLSession.shared
    urlRequest.httpMethod = requestType
    urlRequest.httpBody = requestBody
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
   // urlRequest.timeoutInterval = 5
    urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
    
    let task = session.dataTask(with: urlRequest, completionHandler: {
        (data, response, error) in
        ViewControllerUtils().hideActivityIndicator(uiView: view)
        guard let responseData = data else {
            print(error!._code)
            if(error!._code == -1001) {
                print("time out")
                          
            }
            print("Error: did not receive data")
            
            completionHandler(nil, error)
            return
        }
        guard error == nil else {
            completionHandler(nil, error!)
            return
        }
        
        do {
            let response = try JSONDecoder().decode(ApiContainer<T>.self, from: responseData)
            completionHandler(response, nil)
        }
        catch {
            print("error trying to convert data to JSON")
            print(error)
            completionHandler(nil, error)
        }
        
    })
    task.resume()
}










func makeDelete(httpMethod: String = "DELETE",
                    endpoint: String,
                    parameters: [String: String?],
                    completionHandler: @escaping (Meta?, BackendError?) -> ()) {
    
    let token = DAKeychain.shared["token"]
    let fullEndPoint = baseEndPoint + endpoint
    
    guard var urlComponents = URLComponents(string: fullEndPoint) else {
        print("Invalid endpoint")
        return
    }
    
    // Build an array containing the parameters the user specified
    var queryItems = parameters.map { key, value in URLQueryItem(name: key, value: value) }
    
    // Optional: Add default values for parameters that the user missed
    if !queryItems.contains(where: { $0.name == "token" }) {
        queryItems.append(URLQueryItem(name: "token", value: token))
    }
    
    // Add these parameters to the URLComponents
    urlComponents.queryItems = queryItems
    
    // And here's your final URL
    guard let url = urlComponents.url else {
        print("Cannot construct URL")
        return
    }
    print(url)
    var urlRequest = URLRequest(url: url)
    let session = URLSession.shared
    
    //  urlRequest.httpMethod = "GET"
    urlRequest.httpMethod = httpMethod
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    

    let task = session.dataTask(with: urlRequest, completionHandler: {
        (data, response, error) in
        guard error == nil else {
            //completionHandler(nil, error as? BackendError)
            let error = BackendError.objectDeletion(reason: "Server Error")
            completionHandler(nil, error)
            return
        }
        
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{
                    print("deleted")
                    let response = Meta(sucess: "yes", message: "deleted")
                    completionHandler(response, nil)
                    return
                }
                else if (httpResponse.statusCode == 404) {
                    let error = BackendError.objectDeletion(reason: "not found")
                    completionHandler(nil, error)
                    return
                }
                else {
                    let error = BackendError.objectDeletion(reason: "can't delete")
                    completionHandler(nil, error)
                    return
                }
            }
      
        
        
        
    })
    task.resume()
}


@discardableResult
func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
    let mainContainer: UIView = UIView(frame: viewContainer.frame)
    mainContainer.center = viewContainer.center
    mainContainer.backgroundColor = UIColor.lightGray
    mainContainer.alpha = 0.5
    mainContainer.tag = 789456123
    mainContainer.isUserInteractionEnabled = true


    
    let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
    viewBackgroundLoading.center = viewContainer.center
    viewBackgroundLoading.backgroundColor = UIColor.black
    viewBackgroundLoading.alpha = 0.5
    viewBackgroundLoading.clipsToBounds = true
    viewBackgroundLoading.layer.cornerRadius = 15
    
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
    activityIndicatorView.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.whiteLarge
    activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
    if startAnimate!{
        viewBackgroundLoading.addSubview(activityIndicatorView)
        mainContainer.addSubview(viewBackgroundLoading)
        viewContainer.addSubview(mainContainer)
        activityIndicatorView.startAnimating()
    }else{
        for subview in viewContainer.subviews{
            if subview.tag == 789456123{
                subview.removeFromSuperview()
            }
        }
}
    return activityIndicatorView
}


func getRandomColor(view: UIView) {
    UIView.animate(withDuration: 2.0, animations: { () -> Void in
        view.backgroundColor = UIColor.white
    })
}





//
//https://www.zoho.com/ca/subscriptions/kb/invoices/different-invoice-status.html
//Sent
//Paid
//Overdue
//Void
//Write Off
//Draft
//
//
