//
//  Quiz.swift
//  Quiz
//
//  Created by Balaji Murali on 1/17/23.
//

import Foundation

class Quiz {
    let id: Int
    let topic: String
    let questions: [QuizQuestion]
    
    init(id: Int, topic: String, questions: [QuizQuestion]) {
        self.id = id
        self.topic = topic
        self.questions = questions
    }
}
