//
//  QuizDataChangeProtocols.swift
//  Quiz
//
//  Created by Balaji M on 1/18/23.
//

import Foundation

protocol CreateQuizChoiceUpdate {
    func onUpdateQuizChoice(choiceId: Int, content: String, isAnswer: Bool)
}
