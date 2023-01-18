//
//  QuizData.swift
//  Quiz
//
//  Created by Balaji M on 1/18/23.
//

import Foundation

class QuizData {
    private static var quizzes = [Quiz]()
    
    static func quizzesCount() -> Int {
        return quizzes.count
    }
    
    static func createQuiz(topic: String, questions: [QuizQuestion]) {
        quizzes.append(
            Quiz(id: quizzes.count, topic: topic, questions: questions)
        )
    }
    
    static func getQuiz(quizId: Int) -> Quiz? {
        if quizzes.count > quizId {
            return quizzes[quizId]
        }
        return nil
    }
}
