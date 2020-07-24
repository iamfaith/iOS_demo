//
//  CaptureImageView.swift
//  anime
//
//  Created by faith on 2020/7/23.
//  Copyright © 2020 iamfaith. All rights reserved.
//

import SwiftUI

struct CaptureImageView {
    
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var videoInfo: VideoInfo?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image, videoInfo: $videoInfo)
    }
}


extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
            //["public.image", "public.movie"]
        
        if #available(iOS 11.0, *) {
            picker.videoExportPreset = "AVAssetExportPresetPassthrough"
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}
