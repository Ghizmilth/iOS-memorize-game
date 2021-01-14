//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Hidaner Ferrer on 1/9/21.
//



//View
import SwiftUI

struct EmojiMemoryGameView: View {
    
    // This represents the connection between View and ViewModel controller
    // This @ObservedObject is because the 'EmojiMemoryGame' has a constraint of ObservableObject and once it changes over there, it tells the View to re-draw the screen
    @ObservedObject var viewModel: EmojiMemoryGame
    
    // The 'body' var is for the system to obtain it and then showing it on the view
    var body: some View {
        // The code below is a View Builder and we're not allowed to create Variables in them
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
                .padding()
                .foregroundColor(.orange)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.viewModel.resetGame()
                }
            }, label: { Text("New Game") })
        }
    }
}

struct CardView: View {
    
    var card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    // allows the pie to access the model bonus remaining
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack() {
                Group{
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                           .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)    
                    }
                }.padding(5).opacity(0.4)
               
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360: 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
             .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
            
        }
     }

    
    
    // We are using this MARK to get the numbers from our declarations above into contants so the code is cleaner
    // MARK: - Drawing Constants
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}


    



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
