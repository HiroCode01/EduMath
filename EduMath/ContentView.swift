//
//  ContentView.swift
//  EduMath
//
//  Created by HiRO on 09/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var randomSelectedFirstNumber:  Int
    @State private var randomSelectedSecondNumber: Int
    @State private var answerOptions: [Int]
    
    init() {
        let first  = Int.random(in: 2...20)
        let second = Int.random(in: 1...12)
        
        _randomSelectedFirstNumber  = State(initialValue: first)
        _randomSelectedSecondNumber = State(initialValue: second)
        _answerOptions              = State(initialValue: buttonAnswerAndRandomAnswers(first, second))
    }
    
    @State private var scorePoints: Int = 0
    @State private var isGameOver: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Text("\(randomSelectedFirstNumber) x \(randomSelectedSecondNumber) = ?")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer().frame(height: 200)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 20){
                ForEach(answerOptions, id: \.self) { option in
                    Button("\(option)") {
                        //Something
                    }
                    .mainButtonStyle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

//View Design For Main Buttons
struct MainButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .frame(width: 100, height: 50)
            .foregroundStyle(.white)
            .background(Color.blue)
            .clipShape(.rect(cornerRadius: 15))
    }
}

extension View {
    func mainButtonStyle() -> some View {
        modifier(MainButtonStyle())
    }
}

//Function to get an asnwer and 3 random wrong asnwers for buttons
func buttonAnswerAndRandomAnswers(_ firstNumber: Int, _ secondNumber: Int) -> Array<Int> {
    let correct = firstNumber * secondNumber
    var answers = [correct]
    
    while answers.count < 4 {
        let wrong = Int.random(in: 1...12 * firstNumber)
        
        if !answers.contains(wrong) {
            answers.append(wrong)
        }
    }
    return answers.shuffled()
}
