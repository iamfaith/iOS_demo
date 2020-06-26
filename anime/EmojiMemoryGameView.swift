//
//  EmojiMemoryGameView.swift
//  bbbb
//
//  Created by faith on 2020/6/24.
//  Copyright © 2020 faith. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @State private var selection = 0
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        //        HStack(content: {
        //            //            Text("hello")
        //            //            ForEach(0..<4, content: { index in
        //            //                CardView(isFaceUp: true)
        //            //            })
        //
        //            ForEach(viewModel.cards) { card in
        //                CardView(card: card).onTapGesture {
        //                    self.viewModel.choose(card: card)
        //                }
        //            }
        //        })
        
        Grid(items: viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                self.viewModel.choose(card: card)
            }
            .padding(5)
        }
        .padding()
        .foregroundColor(Color.orange)
        
        //        TabView(selection: $selection){
        //            VStack {
        //                Image("turtlerock")
        //                Text("demo")
        //                Text("First View")
        //                    .font(.title)
        //                    .tabItem {
        //                        VStack {
        //                            Image("first")
        //                            Text("First")
        //                                .font(.title)
        //                        }
        //                    }
        //                .tag(0)
        //            }
        //            Text("Second View")
        //                .font(.title)
        //                .tabItem {
        //                    VStack {
        //                        Image("second")
        //                        Text("Second")
        //                    }
        //                }
        //                .tag(1)
        //        }
    }
}


struct CardView: View {
    var card: MemoryGame<String>.Card
    //    var isFaceUp: Bool = false
    var body: some View {
        GeometryReader(content: { geometry in
            self.body(for: geometry.size)
        })
        
    }
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)//.foregroundColor(Color.orange)
                Text(card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
        }.font(Font.system(size: fontSize(for: size)))
        
    }
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.height, size.width) * 0.75
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
