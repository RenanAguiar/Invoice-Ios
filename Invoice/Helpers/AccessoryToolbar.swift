import UIKit

protocol AccessoryToolbarDelegate: class {
    func doneClicked(for textField: UITextField)
    func cancelClicked(for textField: UITextField)
}

class AccessoryToolbar: UIToolbar {
    
    fileprivate let textField: UITextField
    
    weak var accessoryDelegate: AccessoryToolbarDelegate?
    
    init(for textField: UITextField) {
        self.textField = textField
        super.init(frame: CGRect.zero)
        
        self.barStyle = .default
        self.isTranslucent = true
        self.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        self.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        self.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func doneClicked() {
        accessoryDelegate?.doneClicked(for: self.textField)
    }
    
    @objc fileprivate func cancelClicked() {
        accessoryDelegate?.cancelClicked(for: self.textField)
    }
}
