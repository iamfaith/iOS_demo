//
//  Coordinator.swift
//  anime
//
//  Created by faith on 2020/7/23.
//  Copyright © 2020 iamfaith. All rights reserved.
//

import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    @Binding var videoInCoordinator: VideoInfo?
    
    init(isShown: Binding<Bool>, image: Binding<Image?>, videoInfo: Binding<VideoInfo?>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        _videoInCoordinator = videoInfo
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //     guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        
//        print("videoURL:\(String(describing: videoURL))")
        videoInCoordinator = VideoUtil.getVideoInfo(videoURL)
        //     imageInCoordinator = Image(uiImage: unwrapImage)
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}
