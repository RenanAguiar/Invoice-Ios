//
//  CustomActivityIndicator.swift
//  tes
//
//  Created by Renan Aguiar on 2018-01-09.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import Foundation
import UIKit
class CustomActivityIndicator {
    
    var viewContainer = UIView()
    var startAnimate:Bool? = true
    var mainContainer = UIView()
    var activityIndicatorView = UIActivityIndicatorView()
    var viewBackgroundLoading = UIView()

    init(viewContainer: UIView, startAnimate: Bool? = true) {

        self.viewContainer = viewContainer
        self.startAnimate = startAnimate
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let mainContainer: UIView = UIView(frame: self.viewContainer.frame)
        mainContainer.center = self.viewContainer.center
        mainContainer.backgroundColor = UIColor.lightGray
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = true
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = self.viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.black
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
    }
    
    func start() -> UIActivityIndicatorView  {
        DispatchQueue.main.async(execute: {
            print("start")
            self.viewBackgroundLoading.addSubview(self.activityIndicatorView)
            self.mainContainer.addSubview(self.viewBackgroundLoading)
            self.viewContainer.addSubview(self.mainContainer)
            self.activityIndicatorView.startAnimating()
        })
        return activityIndicatorView
    }
    
    func stop() {
        DispatchQueue.main.async(execute: {
            print("stop")
            for subview in self.viewContainer.subviews {
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        })
    }
    
}

