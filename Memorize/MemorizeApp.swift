//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Hidaner Ferrer on 1/9/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            let game = EmojiMemoryGame()
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
