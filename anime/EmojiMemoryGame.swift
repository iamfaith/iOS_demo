//
//  EmojiMemoryGame.swift
//  bbbb
//
//  Created by faith on 2020/6/25.
//  Copyright © 2020 faith. All rights reserved.
//

import SwiftUI

//func createCardContent(pairIndex: Int) -> String {
//    return "🥺"
//}
// only works for class
class EmojiMemoryGame: ObservableObject {
    // glass door private(set)
    //    private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: {pairIndex  in "🥺"
    //    })
    //property wrapper  automatically call objectWillChange.send()
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
//    var objectWillChange: ObservableObjectPublisher
        
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🥺", "😂", "😇"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) {pairIndex  in
            return emojis[pairIndex]
        }
    }
    
    //MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        //        return model.cards
        model.cards
    }
    
    // MARK: - Intents(s)
    func choose(card: MemoryGame<String>.Card) {
        
        model.choose(card: card)
    }
    
}
