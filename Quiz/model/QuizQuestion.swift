//
//  QuizQuestion.swift
//  Quiz
//
//  Created by Balaji Murali on 1/17/23.
//

import Foundation

class QuizQuestion {
    let id: Int
    var question: String
    var choices: [QuizChoice]
    
    init(id: Int, question: String, choices: [QuizChoice]) {
        self.id = id
        self.question = question
        self.choices = choices
    }
}
