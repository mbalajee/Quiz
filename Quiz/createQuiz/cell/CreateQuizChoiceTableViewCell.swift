//
//  CreateQuizTableViewCell.swift
//  Quiz
//
//  Created by Balaji M on 1/17/23.
//

import UIKit

class CreateQuizChoiceTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textViewChoice: UITextView!
    @IBOutlet weak var switchAnswer: UISwitch!
    
    var dataChangeListener: CreateQuizChoiceUpdate?
    
    private var choiceId = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        textViewChoice.delegate = self
        switchAnswer.addTarget(self, action: #selector(switchValueChanged), for: UIControl.Event.valueChanged)
    }
    
    func update(questionId: Int, quizChoice: QuizChoice) {
        choiceId = quizChoice.id
        textViewChoice.text = quizChoice.content
        switchAnswer.isOn = quizChoice.isAnswer
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        informDataChangeListener()
    }

    @objc func switchValueChanged() {
        informDataChangeListener()
    }
    
    private func informDataChangeListener() {
        dataChangeListener?.onUpdateQuizChoice(
            choiceId: choiceId,
            content: textViewChoice.text ?? "",
            isAnswer: switchAnswer.isOn
        )
    }
}
