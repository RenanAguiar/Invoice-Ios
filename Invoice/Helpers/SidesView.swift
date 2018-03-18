//
//  SidesView.swift
//  CustomTextFields
//
//  Created by Khalid Afridi on 2017-03-28.
//  Copyright © 2017 SwiftyNinja. All rights reserved.
//


import UIKit


class SidesView: UIView {
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false    
        return imgView
    }()
    
    var icon: UIImage? {
        didSet {
            if let icon = icon {
                UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.imageView.image = icon
                }, completion: nil)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        if let icon = icon {
            imageView.image = icon
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

