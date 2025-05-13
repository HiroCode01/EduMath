//
//  ContentView.swift
//  EduMath
//
//  Created by HiRO on 09/05/25.
//

import SwiftUI

struct ContentView: View {
    //Game main stats
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
    
    //Game control
    @State private var scorePoints: Int = 0
    @State private var isGameOver: Bool = false
    
    //Column to sort buttons
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    //Animation
    @State private var textRotation = 0.0
    
    var body: some View {
        ZStack {
            //Background View
            BackgroundGradient()
            
            //Main View
            VStack {
                Text("Score: \(scorePoints)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .animation(.easeInOut)
                
                Spacer()
                
                Text("\(randomSelectedFirstNumber) x \(randomSelectedSecondNumber) = ?")
                    .animation(.spring)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .backRectStyle(300, 120)
                    .rotation3DEffect(.degrees(textRotation), axis: (x: 1, y: 0, z: 0))
                
                Spacer()
                Spacer()
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 20){
                    ForEach(answerOptions, id: \.self) { option in
                        Button("\(option)") {
                            buttonTapped(option)
                            withAnimation(.spring(duration: 0.8, bounce: 0.5)) {
                                textRotation += 360
                            }
                        }
                        .backRectStyle(120, 120)
                    }
                }
                Spacer()
            }
        }
        .background(.white)
    }
    
    //Function to count the score
    func buttonTapped(_ numberTapped: Int) {
        if numberTapped == randomSelectedFirstNumber * randomSelectedSecondNumber {
            scorePoints += 1
        }
        
        guard scorePoints < 10 else {
            return restartGame()
        }
        
        askNewQuestion()
    }
    
    //Function to start a new round
    func askNewQuestion() {
        randomSelectedFirstNumber = Int.random(in: 2...20)
        randomSelectedSecondNumber = Int.random(in: 1...12)
        textRotation = 0
        answerOptions = buttonAnswerAndRandomAnswers(randomSelectedFirstNumber, randomSelectedSecondNumber)
    }
    
    //Function to restart the full game & score
    func restartGame() {
        scorePoints = 0
        askNewQuestion()
    }
}

#Preview {
    ContentView()
}

//View Design For Main Buttons
struct BackgroundReactangleWithAnimatedGradientBorder: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    
    @State private var rotation = Angle.degrees(0)
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .padding(20)
            .frame(maxWidth: width, minHeight: height)
            .foregroundStyle(
                LinearGradient(
                    colors: [.yellow, .pink, .orange, .mint],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.yellow, .pink, .cyan, .mint, .orange, .purple, .pink, .blue, .yellow]),
                            center: .center,
                            angle: rotation
                        ),
                        lineWidth: 12
                    )
            )
            .clipShape(.rect(cornerRadius: 10))
            .onAppear {
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                    rotation = .degrees(360)
                }
            }
            .shadow(radius: 10, x: -10, y: 10)
    }
}


extension View {
    func backRectStyle(_ width: CGFloat, _ height: CGFloat) -> some View {
        modifier(BackgroundReactangleWithAnimatedGradientBorder(width: width, height: height))
    }
}

//Function to get an asnwer and 3 random wrong asnwers for buttons
func buttonAnswerAndRandomAnswers(_ firstNumber: Int, _ secondNumber: Int) -> [Int] {
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

//Background Gradient
struct BackgroundGradient: View {
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            // 9 points laid out in a uniform 3×3 grid
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.5, 1.0], [0.7, 0.5], [1.0, 0.7],
                [0.0, 1.0], [0.0, 0.5], [0.0, 0.5],
            ],
            colors: [
                .yellow,   // top-left: sunny yellow
                .pink,     // top-center: bubblegum pink
                .cyan,     // top-right: sky blue
                .mint,     // mid-left: mint green
                .orange,   // center: tangerine orange
                .purple,   // mid-right: soft lavender
                .pink.opacity(0.7),  // bottom-left: lighter pink
                .blue.opacity(0.8),  // bottom-center: playful blue
                .yellow.opacity(0.8) // bottom-right: warm yellow
            ]
        )
        .ignoresSafeArea()      // fill the whole screen
        .shadow(color: .gray.opacity(0.4), radius: 20, x: -5, y: 5)
    }
}
