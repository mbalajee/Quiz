//
//  PlayQuizViewController.swift
//  Quiz
//
//  Created by Balaji M on 1/18/23.
//

import UIKit

class PlayQuizViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewQuiz: UITableView!
    @IBOutlet weak var buttonNextSubmit: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    
    var quizId: Int!
    
    private let SECTION_QUESTION = 0
    private let SECTION_CHOICE = 1
    
    private var currentQuestion = 0
    private var questions: [QuizQuestion]!
    
    // Mapping between questionId and the selected choices to verify
    private var answers = [Int : [QuizChoice]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = QuizData.getQuiz(quizId: quizId)?.topic ?? "Unnamed quiz"

        tableViewQuiz.estimatedRowHeight = 100
        tableViewQuiz.rowHeight = UITableView.automaticDimension
        tableViewQuiz.delegate = self
        tableViewQuiz.dataSource = self
        
        // Create a copy of all questions to avoid showing results from original QuizChoice
        // TODO: Invalid quizId would crash the app.
        questions = QuizData.getQuiz(quizId: quizId)?.questions.map({ question in
            QuizQuestion(id: question.id, question: question.question, choices: question.choices.map({ choice in
                QuizChoice(id: choice.id, content: choice.content, isAnswer: false)
            }))
        })
        
        if questions.count == 1 {
            buttonPrevious.isHidden = true
            buttonNextSubmit.setTitle("Submit", for: .normal)
        }
    }
    
    @IBAction func onClickNext() {
        currentQuestion += 1
        
        if currentQuestion == questions.count - 1 {
            buttonNextSubmit.setTitle("Submit", for: .normal)
        }
        
        // If exceeded set it to the last question id and submit the quiz
        if currentQuestion == questions.count {
            currentQuestion = questions.count - 1
            submitQuiz()
        }
        
        tableViewQuiz.reloadData()
    }
    
    @IBAction func onClickPrevious() {
        buttonNextSubmit.setTitle("Next", for: UIControl.State.normal)
        currentQuestion -= 1
        // If subceeded set it to first question id
        if currentQuestion < 0 {
            currentQuestion = 0
        }
        tableViewQuiz.reloadData()
    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int
        
        switch section {
        case SECTION_QUESTION: rows = 1
        case SECTION_CHOICE: rows = questions[currentQuestion].choices.count
        default: rows = 0
        }
        
        return rows
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case SECTION_QUESTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizQuestion", for: indexPath) as! CreateQuizQuestionTableViewCell
            cell.update(quizQuestion: questions[currentQuestion])
            return cell
            
        case SECTION_CHOICE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizChoice", for: indexPath) as! CreateQuizChoiceTableViewCell
            cell.dataChangeListener = self
            let question = questions[currentQuestion]
            cell.update(questionId: question.id, quizChoice: question.choices[indexPath.row])
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    private func saveChoices() {
        
        let question = questions[currentQuestion]
        
        for row in 0..<question.choices.count {
            let choiceIndexPath = IndexPath(row: row, section: SECTION_CHOICE)
            if let choiceCell = tableViewQuiz.cellForRow(at: choiceIndexPath) as? CreateQuizChoiceTableViewCell {
                question.choices[row].isAnswer = choiceCell.switchAnswer.isOn
            }
        }
    }
    
    private func submitQuiz() {
        let originalQuestions = QuizData.getQuiz(quizId: quizId)!.questions // TODO: handle nullability
        var correctAnswers = 0
        for original in originalQuestions {
            let submittedAnswers = questions[original.id].choices
            // All choices in the originalQuestion should match all choices in the submitted question
            let isCorrect = original.choices.allSatisfy { expectedAnswer in
                submittedAnswers[expectedAnswer.id].isAnswer == expectedAnswer.isAnswer
            }
            if isCorrect {
                correctAnswers += 1
            }
        }
        
        let quizTopic = QuizData.getQuiz(quizId: quizId)?.topic ?? "Unnamed quiz"
        presentAlert(
            title: quizTopic,
            subtitle: "Result: \(correctAnswers) \\ \(questions.count)",
            actionTitle: "Play again",
            cancelTitle: "Exit",
            cancelHandler: { _ in
                self.navigationController?.popViewController(animated: true)
            },
            actionHandler: { text in
                self.currentQuestion = 0
                self.tableViewQuiz.reloadData()
            }
        )
    }
}

extension PlayQuizViewController: CreateQuizChoiceUpdate {
    func onUpdateQuizChoice(choiceId: Int, content: String, isAnswer: Bool) {
        questions[currentQuestion].choices[choiceId].isAnswer = isAnswer
    }
}

