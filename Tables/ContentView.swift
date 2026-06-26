//
//  ContentView.swift
//  Tables
//
//  Created by Carlos Ramirez on 6/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var maxTable = 12
    @State private var score = 0
    @State private var round = 1
    @State private var gameStarted = false
    @State private var answer: Int?
    @State private var gameQuestions: [Question] = []
    @State private var gameQuestion: Question?
    @State private var showAnswerAlert = false
    @State private var answerAlertMessage = ""
    
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
        if !gameStarted {
            VStack {
                Text("Multiplication Practice")
                
                Picker("Up to What Table?", selection: $maxTable) {
                    ForEach(1..<13) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel)
                
                Button("Start") {
                    StartGame()
                }
            }
            .padding()
        } else {
            VStack {
                Text(gameQuestion?.text ?? "")
                TextField("Answer", value: $answer, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                Button("Submit Answer") {
                    SubmitAnswer()
                }
                .alert("Test", isPresented: $showAnswerAlert) {
                    
                } message: {
                    Text(answerAlertMessage)
                }
            }
        }
       
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
                
                gameQuestions = questionObject.filter {
                    $0.table <= maxTable
                }
                
//                let randomQuestion = allowedQuestions.randomElement()!
                gameQuestion = gameQuestions.randomElement()!
                gameStarted.toggle()
            }
        }
    }
    
    func SubmitAnswer() {
        if gameQuestion.map(\.answer) == answer {
            score += 1
            answerAlertMessage = "You got it dude! Your score is now \(score)"
        } else {
            
            if let correctAnswer = gameQuestion {
                answerAlertMessage = "You is dumb! The correct answer is \(correctAnswer.answer)"
            } else {
                answerAlertMessage = "Something went wrong. No answer found."
            }
        }
        showAnswerAlert.toggle()
    }
}

#Preview {
    ContentView()
}
