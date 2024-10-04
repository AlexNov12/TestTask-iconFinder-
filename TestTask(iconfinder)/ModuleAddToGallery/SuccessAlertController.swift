//
//  SuccessAlertController.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class SuccessAlertController: UIViewController {
    
    func showSaveSuccessAlert() {
        let alertViewController = UIAlertController(
            title: "Success",
            message: "Save was successfull",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        )
        
        alertViewController.addAction(action)
        
        if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(alertViewController, animated: true, completion: nil)
        }
    }
}
