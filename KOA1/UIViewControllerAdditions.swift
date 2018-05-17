//
//  UIViewControllerAdditions.swift
//  KOA1
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import UIKit

extension UIViewController {
    func showGenericAlertWith(title: String?, message: String?, buttonTitle: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlertWith(errorMessage: String?) {
        showGenericAlertWith(title: "Error!", message: errorMessage, buttonTitle: "OK")
    }
}
