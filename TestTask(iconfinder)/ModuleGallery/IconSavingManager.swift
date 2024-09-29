//
//  IconSavingManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit
import Photos

protocol IconSavingManagerProtocol {
    func saveToGallery(image: UIImage)
}

final class IconSavingManager: NSObject, IconSavingManagerProtocol {
    
    private let permissionAlert: PermissionAlertControllerProtocol
    private let successAlert: SuccessAlertControllerProtocol
    
    init(permissionAlert: PermissionAlertControllerProtocol, successAlert: SuccessAlertControllerProtocol) {
        self.permissionAlert = permissionAlert
        self.successAlert = successAlert
    }
    
    func saveToGallery(image: UIImage) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .restricted {
                DispatchQueue.main.async { [weak self] in
                    self?.permissionAlert.showAccessAlert()
                }
            } else {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompleted), nil)
            }
        }
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            self.successAlert.showSaveSuccessAlert()
        }
    }
}
