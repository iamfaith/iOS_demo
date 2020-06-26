//
//  MemoryGame.swift
//  bbbb
//
//  Created by faith on 2020/6/25.
//  Copyright © 2020 faith. All rights reserved.
//

import Foundation

// Model
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp}.only
//            let faceUpCardIndices = cards.indices.filter { (index) -> Bool in
//                cards[index].isFaceUp
//            }
            // $0 first argument
//            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp}.only
            
//            var faceUpCardIndices = [Int]()
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first
//            } else {
//                return nil
//            }
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
        
    }
    mutating func choose(card: Card) {
        //        print("card chosen: \(card)")
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                //                indexOfTheOneAndOnlyFaceUpCard = nil
                self.cards[chosenIndex].isFaceUp = true
            } else {
                //                for index in cards.indices {
                //                    cards[index].isFaceUp = false
                //                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            //            self.cards[chosenIndex].isFaceUp = true
        }
    }
    
    //    func index(of card: Card) -> Int{
    //        for index in 0..<self.cards.count {
    //            if self.cards[index].id == card.id {
    //                return index
    //            }
    //        }
    //        return 0 //TODO: bogus!
    //    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
