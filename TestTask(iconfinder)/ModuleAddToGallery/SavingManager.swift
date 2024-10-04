//
//  IconSavingManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit
import Photos

final class SavingManager: NSObject {
    
    private let permissionAlert = PermissionAlertController()
    private let successAlert = SuccessAlertController()
    
    static let shared = SavingManager()
    
    func saveToGallery(image: UIImage) {
        if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .restricted {
            permissionAlert.showAccessAlert()
        } else {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompleted), nil)
        }
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        successAlert.showSaveSuccessAlert()
    }
}
