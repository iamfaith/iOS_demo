//
//  TextView.swift
//  anime
//
//  Created by faith on 2020/7/23.
//  Copyright © 2020 iamfaith. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    
    @Binding var text: String
//    var fontStyle: UIFont.TextStyle
    var isEditable: Bool = false
//    var backgroundColor: UIColor = .black
//    var borderColor: UIColor
//    var borderWidth: CGFloat
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let myTextView = UITextView()
        myTextView.delegate = context.coordinator
        
//        myTextView.font = UIFont.preferredFont(forTextStyle: fontStyle)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = isEditable
        myTextView.isUserInteractionEnabled = true
//        myTextView.backgroundColor = backgroundColor
//        myTextView.layer.borderColor = borderColor.cgColor
//        myTextView.layer.borderWidth = borderWidth
        myTextView.layer.cornerRadius = 8
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: TextView
        
        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
