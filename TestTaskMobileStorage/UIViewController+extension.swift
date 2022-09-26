//
//  UIViewController+extension.swift
//  TestTaskMobileStorage
//
//  Created by Konstantin Gracheff on 26.09.2022.
//

import UIKit

extension UIViewController {
    func showSaveAlert(title:String? = "Add mobile",
                         subtitle:String? = "Type model phone and IMEI",
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         firstInputPlaceholder:String? = "IMEI",
                         secondInputPlaceholder:String? = "Model",
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ firstText: String?, _ secondText: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = firstInputPlaceholder
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = secondInputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            
            guard let model = alert.textFields?[0],
                  let imei = alert.textFields?[1] else {
                actionHandler?(nil, nil)
                return
            }
            
            actionHandler?(model.text, imei.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showFindAlert(title: String? = "Find mobile",
                         subtitle: String? = nil,
                         actionTitle: String? = "OK",
                         cancelTitle: String? = "Cancel",
                         inputPlaceholder: String? = "Enter IMEI",
                       inputKeyboardType: UIKeyboardType = UIKeyboardType.numberPad,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK",
                               style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
