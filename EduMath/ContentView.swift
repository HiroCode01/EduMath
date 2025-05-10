//
//  ContentView.swift
//  EduMath
//
//  Created by HiRO on 09/05/25.
//

import SwiftUI

struct ContentView: View {
    private var multiplicationTableNumbers: [Int] = Array(2...20)
    
    @State private var randomSelectedFirstNumber = Int.random(in: 2...20)
    @State private var randomSelectedSecondNumber = Int.random(in: 1...12)
    
    var body: some View {
        VStack {
            
            Text("\(randomSelectedFirstNumber) x \(randomSelectedSecondNumber) = ?")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Your answer", text: .constant(""))
                .padding()
                .background(Color.gray.opacity(0.2))
                .frame(width: 200, height: 50, alignment: .center)
                .cornerRadius(8)
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    ContentView()
}
