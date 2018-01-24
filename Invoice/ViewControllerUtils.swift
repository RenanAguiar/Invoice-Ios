import Foundation
import UIKit

class ViewControllerUtils {

    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func showActivityIndicator(uiView: UIView) {
        
        self.container.frame = uiView.frame
        self.container.center = uiView.center
        self.container.backgroundColor = UIColor.white
        self.container.alpha = 0.7
        self.container.tag = 789456123
        
        loadingView.frame = CGRect(x:0, y:0, width:80, height:80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
        
        DispatchQueue.main.async {
            self.loadingView.addSubview(self.activityIndicator)
            self.container.addSubview(self.loadingView)
        uiView.addSubview(self.container)
        self.activityIndicator.startAnimating()
        }
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        DispatchQueue.main.async {
        if let viewWithTag = uiView.viewWithTag(789456123) {
            viewWithTag.removeFromSuperview()
        }
        else {
            return
        }
        }
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}
