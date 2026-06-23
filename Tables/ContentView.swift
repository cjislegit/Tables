//
//  ContentView.swift
//  Tables
//
//  Created by Carlos Ramirez on 6/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var maxTable = 12
    
    struct Question {
        let table: Int
        let mutilpier: Int
        
        var text: String {
            "\(table) * \(mutilpier)"
        }
        
        var answer: Int {
            table * mutilpier
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear(perform: StartGame)
        .padding()
    }
    
    func StartGame() {
        if let questionsURL = Bundle.main.url(forResource: "questions", withExtension: "txt") {
            if let questions = try? String(contentsOf: questionsURL, encoding: .utf8) {
                let allQuestions = questions.split(separator: "\n")
                let questionObject = allQuestions.compactMap { question -> Question? in
                    let parts = question.components(separatedBy: " ")
                    
                    guard parts.count == 3,
                        let table = Int(parts[0]),
                        let multiplier = Int(parts[2])
                    else { return nil }
                    
                    return Question(table: table, mutilpier: multiplier)
                }
                
                let allowedQuestions = questionObject.filter {
                    $0.table <= maxTable
                }
                
                let randomQuestion = allowedQuestions.randomElement()!
                print(randomQuestion.text)
            }
        }
    }
}

#Preview {
    ContentView()
}
