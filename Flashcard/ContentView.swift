//
//  ContentView.swift
//  Flashcard
//
//  Created by Schyla Solms on 10/5/24.
//
import SwiftUI

struct ContentView: View {
    @State private var cards: [Card] = Card.mockedCards
    @State private var deckId: Int = 0
    @State private var cardsToPractice: [Card] = []
    @State private var cardsMemorized: [Card] = []
    @State private var createCardViewPresented = false

    var body: some View {
        VStack {
            // Reset Button
            Button("Reset") {
                cards = cardsToPractice + cardsMemorized
                cardsToPractice = []
                cardsMemorized = []
                deckId += 1
            }
            .disabled(cardsToPractice.isEmpty)

            // More Practice Button
            Button("More Practice") {
                cards = cardsToPractice
                cardsToPractice = []
                deckId += 1
            }

            // Cards Stack
            ZStack {
                ForEach(cards.indices, id: \.self) { index in
                    CardView(
                        card: cards[index],
                        onSwipedLeft: { removeCard(at: index, to: &cardsToPractice) },
                        onSwipedRight: { removeCard(at: index, to: &cardsMemorized) }
                    )
                    .rotationEffect(.degrees(Double(cards.count - 1 - index) * -5))
                    .animation(.bouncy, value: cards)
                }
            }
            .id(deckId)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Add Flashcard Button with Overlay
            .overlay(alignment: .topTrailing) {
                Button {
                    createCardViewPresented.toggle()
                } label: {
                    Label("Add Flashcard", systemImage: "plus")
                }
            }

            // Sheet for Creating Cards
            .sheet(isPresented: $createCardViewPresented) {
                CreateFlashcardView { card in
                    cards.append(card)
                }
            }
        }
    }

    // Helper function to remove card and append to the target array
    private func removeCard(at index: Int, to targetArray: inout [Card]) {
        guard index < cards.count else { return }
        let removedCard = cards.remove(at: index)
        targetArray.append(removedCard)
    }
}

// Preview for SwiftUI canvas
#Preview {
    ContentView()
}
