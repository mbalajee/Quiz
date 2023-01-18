//
//  ViewControllerExtensions.swift
//  Quiz
//
//  Created by Balaji M on 1/18/23.
//

import Foundation
import UIKit

extension UIViewController {
    func presentInputAlert(title: String? = nil,
                           subtitle: String? = nil,
                           actionTitle: String? = "Create",
                           cancelTitle: String? = "Cancel",
                           inputPlaceholder: String? = nil,
                           inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                           cancelHandler: ((UIAlertAction) -> Void)? = nil,
                           actionHandler: @escaping (_ text: String?) -> Void)    {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action: UIAlertAction) in
            guard let textField = alert.textFields?.first else {
                actionHandler(nil)
                return
            }
            actionHandler(textField.text)
        }))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    func presentAlert(title: String? = nil,
                           subtitle: String? = nil,
                           actionTitle: String? = "Create",
                           cancelTitle: String? = "Cancel",
                           cancelHandler: ((UIAlertAction) -> Void)? = nil,
                           actionHandler: @escaping (_ text: String?) -> Void)    {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action: UIAlertAction) in
            guard let textField = alert.textFields?.first else {
                actionHandler(nil)
                return
            }
            actionHandler(textField.text)
        }))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
