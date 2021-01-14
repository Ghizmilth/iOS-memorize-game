//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Hidaner Ferrer on 1/10/21.
//

import SwiftUI

// ViewModel
// ObservableObject is a constraint for our 'reactive' It only works for classes
class EmojiMemoryGame: ObservableObject {
    // Doorway to talk to the model, it never talks to the View. View talks to the ViewModel
    // @Published is a property wrapper, everytime the var model changes, it will call objectWillChange.send() and we don;t need to use it in oour intents
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    

//    We use this static type of function to be able to initialize our var model
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "🕷", "🕸", "☠️", "🔥"]
        return MemoryGame<String>(numberOfPairsOfcards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
       
    // Thjis peace of code is for attached to the constraint in the header of the class 'ObservavbleObject'
    // This helps to knwo when something changes and updates it accrodingly
    // We don; need this line of code as it comes automatically with our constraint
    // var objectWillChange: ObservableObjectPublisher
    
    // MARK: -Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    
    // MARK: -Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        // This says that this game is going to change, it sends the data once it has happened
        // objectWillChange.send()
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}


