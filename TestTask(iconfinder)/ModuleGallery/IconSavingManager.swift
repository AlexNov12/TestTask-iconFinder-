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
        
        // для проверки, что работает
        let startTime = DispatchTime.now()
        
        DispatchQueue.global(qos: .background).async{ [weak self] in
            guard let self = self else { return }
            if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .restricted {
                PermissionAlertController.shared.showAccessAlert()
            } else {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompleted), nil)
            }
        }
        
        // для проверки, что работает
        let endTime = DispatchTime.now()
        let elapsedTipe = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let milliseconds = Double(elapsedTipe) / 1_000_000
        print("save image stop: \(milliseconds) ms")
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        SuccessAlertController.shared.showSaveSuccessAlert()
    }
}
