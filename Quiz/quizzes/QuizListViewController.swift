//
//  QuizListViewController.swift
//  Quiz
//
//  Created by Balaji M on 1/18/23.
//

import UIKit

class QuizListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewQuiz: UITableView!
    @IBOutlet weak var labelEmptyList: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewQuiz.delegate = self
        tableViewQuiz.dataSource = self
        tableViewQuiz.estimatedRowHeight = 100
        tableViewQuiz.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let emptyList = QuizData.quizzesCount() == 0
        labelEmptyList.isHidden = !emptyList
        tableViewQuiz.isHidden = emptyList
        tableViewQuiz.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuizData.quizzesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let quiz = QuizData.getQuiz(quizId: indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizListCell", for: indexPath)
            cell.textLabel?.text = quiz.topic
            cell.detailTextLabel?.text = "Questions \(quiz.questions.count)"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let quiz = QuizData.getQuiz(quizId: indexPath.row) {
            performSegue(withIdentifier: "PlayQuiz", sender: quiz.id)
        }
    }

    
    // MARK: - Navigation
    
    @IBAction func onClickCreateQuiz() {
        performSegue(withIdentifier: "CreateQuiz", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let playQuizController = segue.destination as? PlayQuizViewController, let quizId = sender as? Int {
            playQuizController.quizId = quizId
        }
    }

}
