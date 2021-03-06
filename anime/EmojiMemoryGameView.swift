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
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        //        ZStack {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(100-90), clockwise: true)
                    .padding(5).opacity(0.4)
                Text(card.content).font(Font.system(size: fontSize(for: size)))
                
            }
                //        .modifier(Cardify(isFaceUp: card.isFaceUp))
                .cardify(isFaceUp: card.isFaceUp)
        }
        //        }
    }
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.height, size.width) * 0.7
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards.first!)
        return EmojiMemoryGameView(viewModel: game)
    }
}
