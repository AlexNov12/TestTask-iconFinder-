//
//  PermissionAlertController.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit

final class PermissionAlertController: UIViewController {
    
    static let shared = PermissionAlertController()
    
    func showAccessAlert() {
        let alertViewController = UIAlertController(
            title: "Permit requirement",
            message: "To save icons, you need to get permission to access the library",
            preferredStyle: .alert
        )
        
        let openSettingAction = UIAlertAction(
            title: "Open settings",
            style: .cancel
        ) { _ in 
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.canOpenURL(settingsURL)
            }
            
        }
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertViewController.addAction(openSettingAction)
        alertViewController.addAction(cancel)
        
        if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene,
        let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(alertViewController, animated: true, completion: nil)
        }
    }
}
