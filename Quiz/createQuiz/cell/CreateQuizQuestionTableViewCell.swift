//
//  CreateQuizQuestionTableViewCell.swift
//  Quiz
//
//  Created by Balaji M on 1/17/23.
//

import UIKit

class CreateQuizQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textViewQuestion: UITextView!

    func update(quizQuestion: QuizQuestion) {
        textViewQuestion.text = quizQuestion.question
    }
}
