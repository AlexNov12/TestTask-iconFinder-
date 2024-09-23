//
//  IconSavingManager.swift
//  TestTask(iconfinder)
//
//  Created by Александр Новиков on 16.09.2024.
//

import UIKit
import Photos

final class IconSavingManager: NSObject {
    
    static let shared = IconSavingManager()
    
    func saveToGallery(image: UIImage) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .restricted {
                PermissionAlertController.shared.showAccessAlert()
            } else {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompleted), nil)
            }
        }
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        SuccessAlertController.shared.showSaveSuccessAlert()
    }
}
