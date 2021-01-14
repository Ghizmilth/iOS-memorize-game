//
//  MemoryGame.swift
//  Memorize
//
//  Created by Hidaner Ferrer on 1/10/21.
//


// Model
import Foundation

// This is a generic type therefor the CardContent is made up and is a generic
struct MemoryGame<CardContent> where CardContent: Equatable {
    // Array ofcards that will be passed to viewModel to then pass to View
    // The struct for this Array is below this code
    // We have this var as private to chaging it, not to read
    private(set) var cards: Array<Card>
    
    // Alloptionals ar einitialized to 'nil'
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    // All function that modify itself, needs to be written 'mutating'
    mutating func choose(card: Card) {
        // On an 'if let' we use commas to use sequencial conditions instead of using '&&'
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    
    // ...(of card: ...) is an external variable 'of' and internal variable 'card'. 'of' comes from the func above
    // The code was changed for firstIndex()
//    func index(of card: Card) -> Int {
//        for index in 0..<self.cards.count {
//            if self.cards[index].id == card.id {
//                return index
//            }
//        }
//        return 0 // TODO: bogus!
//    }
    
    init(numberOfPairsOfcards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfcards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2)) // The last parameter if the Card struct is an id so it is identifiable
            cards.append(Card(content: content, id: pairIndex*2+1)) // With the identifiable, the Viewmodel would not complain about not being able to do so
        }
        cards.shuffle()
    }
    
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int // We add id: Int to be identifiable
   
    
    
    
    // MARK: - Bonus Time
    /* This could gve matching bonus points
    if the user matches the card before a certain
     amount of time passes during which the card is face up */
    
    // can be zero which means "no bonus available" for this card
    var bonusTimeLimit: TimeInterval = 6
    
    // how long this card has ever been face up
    private var faceUpTime: TimeInterval {
        if let lastFaceUpDate = self.lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
    
    // the last time this card was turned face up (and is still face up)
    var lastFaceUpDate: Date?
    // the accumulated time this card has been face up in the past
    // (i.e. not including the current time it's been face up if it is currently so)
    var pastFaceUpTime: TimeInterval = 0
    
    // how much time left before the bonus opportunity runs out
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }
    
    // percentage of the bonus time remaining
    var bonusRemaining: Double {
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
    }
    
    // whether the card was matched during the bonus time period
    var hasEarnedBonus: Bool {
        isMatched && bonusTimeRemaining > 0
    }
    
    // whether we are currently face up, unmatched and have not yet used up the bnonus window
    var isConsumingBonusTime: Bool {
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    
    private mutating func startUsingBonusTime() {
        if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    
    // caled when the card goes back face down (or gets matched)
    private mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
    }
    
    
  }
    
    
    
    
}
