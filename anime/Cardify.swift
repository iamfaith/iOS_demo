//
//  Cardify.swift
//  anime
//
//  Created by faith on 2020/6/26.
//  Copyright © 2020 iamfaith. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
    
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)//.foregroundColor(Color.orange)
                content
            } else {
                //                if !card.isMatched {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
                //                }
            }
        }
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
    
}


extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
