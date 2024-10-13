//
//  CardView.swift
//  Flashcard
//
//  Created by Schyla Solms on 10/7/24.
//
import SwiftUI

struct CardView: View {
    let card: Card
    
    
    var onSwipedLeft: (() -> Void)? // <-- Add closures to be called when user swipes left or right
    var onSwipedRight: (() -> Void)? // <--
    
    @State private var isShowingQuestion = true
    @State private var offset: CGSize = .zero
    
    
    private let swipeThreshold: Double = 200
    
    var body: some View {
        
        
        ZStack {
            
            ZStack { //<-- Wrap existing card background in ZStack in order to position another background behind it

                // Back-most card background
                RoundedRectangle(cornerRadius: 25.0) // <-- Add another card background behind the original
                    .fill(offset.width < 0 ? .red : .green) // <-- Set fill based on offset (swipe left vs right)

                // Front-most card background (i.e. original background)
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(isShowingQuestion ? Color.blue.gradient : Color.indigo.gradient)
                    .shadow(color: .black, radius: 4, x: -2, y: 2)
                    .opacity(1 - abs(offset.width) / swipeThreshold) // <-- Fade out front-most background as user swipes
            }
          
            
            
            VStack(spacing: 20) {
                Text(isShowingQuestion ? "Question" : "Answer")
                    .bold()
                
                Rectangle()
                    .frame(height: 1)
                
                Text(isShowingQuestion ? card.question : card.answer)
            }
            .font(.title)
            .foregroundStyle(.white)
            .padding()
        }
        
        .frame(width: 300, height: 500)
        .onTapGesture {
            isShowingQuestion.toggle()
        }
        .opacity(3 - abs(offset.width) / swipeThreshold * 3)         .rotationEffect(.degrees(offset.width / 20.0)) // <-- Add rotation when swiping
        .offset(CGSize(width: offset.width, height: 0))
        
        .gesture(DragGesture()
            .onChanged { gesture in // <-- onChanged called for every gesture value change, like when the drag translation changes
                let translation = gesture.translation // <-- Get the current translation value of the gesture. (CGSize with width and height)
                print(translation)
                offset = translation
                
            }.onEnded { gesture in  // <-- onEnded called when gesture ends
                
                if gesture.translation.width > swipeThreshold { // <-- Compare the gesture ended translation value to the swipeThreshold
                    print("👉 Swiped right")
                    onSwipedRight?()
                    
                } else if gesture.translation.width < -swipeThreshold {
                    print("👈 Swiped left")
                    onSwipedLeft?()
                    
                } else {
                    print("🚫 Swipe canceled")
                    withAnimation(.bouncy){
                        offset = .zero
                    }
                }
            }
        )
    }
}
                 
        

#Preview {
    CardView(card: Card(
        question: "Located at the southern end of Puget Sound, what is the capitol of Washington?",
        answer: "Olympia"))
}

struct Card: Equatable {
    let question: String
    let answer: String
    
    static let mockedCards = [
           Card(question: "What does CPU stand for in computer architecture?", answer: "Central Processing Unit. It is the main part of a computer responsible for executing instructions and preforming calculations"),
           Card(question: "What is the time complexity of binary search in a sorted array?", answer: "O(log n). Binary search works by dividing the search interval in half repeatedly, making it much faster than linear search for large datasets."),
           Card(question: "Which data structure follows the Last in, First Out (LIFO) principle?", answer: "Stack. In a stack, the last element added is the first one to be removed, similar to stacking plates where the top plate is removed first. "),
           Card(question: "In Object-Oriented programming, what is inheritance?", answer: "Inheritance is a feature that allows a class (child class) to inherit properties and methods from another class (parent class), promoting code reuse and hierarchy."),
           Card(question: "What is the primary purpose of DNS (Domain Name System)?", answer: "DNS translates human-readable domain names (like www.example.com) into IP addresses (like 192.0.2.1) so computers can locate websites on the internet.")
       ]
}
