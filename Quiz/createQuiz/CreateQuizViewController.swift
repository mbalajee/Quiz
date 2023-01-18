//
//  CreateQuizTableViewController.swift
//  Quiz
//
//  Created by Balaji M on 1/17/23.
//

import UIKit

class CreateQuizViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewQuiz: UITableView!
    
    private let SECTION_QUESTION = 0
    private let SECTION_CHOICE = 1
    private let SECTION_ADD = 2
    
    private var allQuestions = [QuizQuestion]()
    private var currentQuestion = QuizQuestion(id: 0, question: "", choices: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewQuiz.estimatedRowHeight = 100
        tableViewQuiz.rowHeight = UITableView.automaticDimension
        tableViewQuiz.delegate = self
        tableViewQuiz.dataSource = self
    }
    
    @IBAction func onClickNext() {
        if createQuestion() {
            // Question has been created successfully, move on to the next question
            currentQuestion = QuizQuestion(id: currentQuestion.id + 1, question: "", choices: [])
            tableViewQuiz.reloadData()
        }
    }
    
    @IBAction func onClickCreate(_ sender: Any) {
        // Call createQuestion to capture the current question (Next is not clicked)
        if createQuestion(), !allQuestions.isEmpty {
            presentInputAlert(title: "Quiz topic") { text in
                QuizData.createQuiz(topic: text ?? "Unnamed quiz", questions: self.allQuestions)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int
        
        switch section {
        case SECTION_QUESTION: rows = 1
        case SECTION_CHOICE: rows = currentQuestion.choices.count
        case SECTION_ADD: rows = 1
        default: rows = 0
        }
        
        return rows
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case SECTION_QUESTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizQuestion", for: indexPath) as! CreateQuizQuestionTableViewCell
            cell.update(quizQuestion: currentQuestion)
            return cell
            
        case SECTION_CHOICE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizChoice", for: indexPath) as! CreateQuizChoiceTableViewCell
            cell.dataChangeListener = self
            cell.update(questionId: currentQuestion.id, quizChoice: currentQuestion.choices[indexPath.row])
            return cell
            
        case SECTION_ADD:
            return tableView.dequeueReusableCell(withIdentifier: "QuizAdd", for: indexPath)
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == SECTION_ADD) {
            currentQuestion.choices.append(
                QuizChoice(id: currentQuestion.choices.count, content: "", isAnswer: false)
            )
            
            let indices = [IndexPath(row: currentQuestion.choices.count - 1, section: SECTION_CHOICE)]
            tableView.insertRows(at: indices, with: .bottom)
        }
    }
    
    private func createQuestion() -> Bool {
        
        let completedQuestion = QuizQuestion(id: allQuestions.count, question: "", choices: [])
        
        let questionIndexPath = IndexPath(row: 0, section: SECTION_QUESTION)
        if let questionCell = tableViewQuiz.cellForRow(at: questionIndexPath) as? CreateQuizQuestionTableViewCell,
           let question = questionCell.textViewQuestion.text,
           !question.isEmpty {
            completedQuestion.question = question
        }
        
        for row in 0..<currentQuestion.choices.count {
            let choiceIndexPath = IndexPath(row: row, section: SECTION_CHOICE)
            if let choiceCell = tableViewQuiz.cellForRow(at: choiceIndexPath) as? CreateQuizChoiceTableViewCell,
               let choice = choiceCell.textViewChoice.text,
               !choice.isEmpty {
                completedQuestion.choices.append(
                    QuizChoice(
                        id: completedQuestion.choices.count,
                        content: choice,
                        isAnswer: choiceCell.switchAnswer.isOn
                    )
                )
            }
        }
        
        if !completedQuestion.question.isEmpty, completedQuestion.choices.count > 1 {
            allQuestions.append(completedQuestion)
            return true
        }
        
        return false
    }
}


extension CreateQuizViewController: CreateQuizChoiceUpdate {
    func onUpdateQuizChoice(choiceId: Int, content: String, isAnswer: Bool) {
        if currentQuestion.choices.count > choiceId {
            currentQuestion.choices[choiceId] = QuizChoice(id: choiceId, content: content, isAnswer: isAnswer)
        }
    }
}
