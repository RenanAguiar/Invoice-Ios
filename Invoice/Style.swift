//
//  Style.swift
//  Invoice
//
//  Created by Renan Aguiar on 2018-01-21.
//  Copyright © 2018 Renan Aguiar. All rights reserved.
//

import Foundation


import UIKit

class ISEColors {
    static let iseGreen = UIColor(red: 141 / 255 , green: 198 / 255 , blue: 63 / 255 , alpha: 1.0 )
    static let iseGray = UIColor(red: 84 / 255 , green: 88 / 255 , blue: 90 / 255 , alpha: 1.0 )
    static let iseOrange = UIColor(red: 246 / 255 , green: 190 / 255 , blue: 0 / 255 , alpha: 1.0 )
    static let iseBlue = UIColor(red: 0 / 255 , green: 114 / 255 , blue: 206 / 255 , alpha: 1.0 )
    static let isePurple = UIColor(red: 131 / 255 , green: 49 / 255 , blue: 119 / 255 , alpha: 1.0 )
    static let iseLightGray = UIColor(red: 217 / 255 , green: 217 / 255 , blue: 214 / 255 , alpha: 1.0 )
}

class ISEStyles {
    static let bodyFont = UIFont(name: "ArialMT" , size: 14.0 )
    static let titleFont = UIFont(name: "Avenir-Light" , size: 32.0 )
    static let normalButtonFont = UIFont(name: "ArialMT" , size: 14.0 )
    static let importantButtonFont = UIFont(name: "Arial-BoldMT" , size: 14.0 )
    
     static let normalFont = UIFont(name: "ArialMT" , size: 14.0 )
    
    static let normalButtonBackgroundColor = ISEColors.iseLightGray
    static let importantButtonBackgroundColor = ISEColors.iseOrange
    static let buttonTextColor = ISEColors.iseGray
}

class NormalButton: UIButton {
    @objc dynamic var titleLabelFont: UIFont! {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
}



class ImportantButton: NormalButton {
}

class TitleLabel: UILabel {
}
class BodyLabel: UILabel {
}
class ThemeManager {
    static func applyTheme() {
//        let proxyNormalButton = NormalButton.appearance()
//        proxyNormalButton.setTitleColor(ISEStyles.buttonTextColor, for: .normal)
//        proxyNormalButton.backgroundColor = ISEStyles.normalButtonBackgroundColor
//        proxyNormalButton.titleLabelFont = ISEStyles.normalButtonFont
//
//        let proxyImportantButton = ImportantButton.appearance()
//        proxyImportantButton.backgroundColor = ISEStyles.importantButtonBackgroundColor
//        proxyImportantButton.titleLabelFont = ISEStyles.importantButtonFont
//
//        let proxyTitleLabel = TitleLabel.appearance()
//        proxyTitleLabel.font = ISEStyles.titleFont
//
//        let proxyBodyLabel = BodyLabel.appearance()
//        proxyBodyLabel.font = ISEStyles.bodyFont
//
//        let proxySegmentedControl = UISegmentedControl.appearance()
//        proxySegmentedControl.tintColor = ISEColors.iseGreen
//
//        let proxyTextField = UITextField.appearance()
//        proxyTextField.backgroundColor = ISEColors.iseLightGray
//
//        let proxySwitch = UISwitch.appearance()
//        proxySwitch.onTintColor = ISEColors.isePurple
        
        let proxyLabel = UILabel.appearance()
      //  proxyLabel.textColor = UIColor.red
        proxyLabel.font = ISEStyles.normalFont
        
    }
}
