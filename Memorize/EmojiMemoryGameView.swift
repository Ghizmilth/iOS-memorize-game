//
//  ContentView.swift
//  Memorize
//
//  Created by Hidaner Ferrer on 1/9/21.
//



//View
import SwiftUI

struct EmojiMemoryGameView: View {
    
    // This represents the connection between View and ViewModel controller
    var viewModel: EmojiMemoryGame
    
    // The 'body' var is for the system to obtain it and then showing it on the view
    var body: some View {
        // The code below is a View Builder and we're not allowed to create Variables in them
        HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(.orange)
        .font(Font.largeTitle)
        
        
    }
}

struct CardView: View {
    
    var card: MemoryGame<String>.Card

    var body: some View {
        ZStack() {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }.aspectRatio(0.75, contentMode: .fit)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
