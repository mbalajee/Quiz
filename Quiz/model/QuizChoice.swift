//
//  QuizChoice.swift
//  Quiz
//
//  Created by Balaji Murali on 1/17/23.
//

import Foundation

class QuizChoice {
    let id: Int
    let content: String
    var isAnswer: Bool
    
    init(id: Int, content: String, isAnswer: Bool) {
        self.id = id
        self.content = content
        self.isAnswer = isAnswer
    }
}
