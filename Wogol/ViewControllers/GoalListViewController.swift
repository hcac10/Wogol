//
//  GoalListViewController.swift
//  Wogol
//
//  Created by Peter Smiley on 9/8/20.
//  Copyright © 2020 HernanPeter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class GoalListViewController: UIViewController {

    @IBOutlet weak var parentStackView: UIStackView!
    
    @IBOutlet weak var goalsScrollView: UIScrollView!
    
    lazy var childStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.layer.borderWidth = 3
        stackView.layer.borderColor = UIColor(red:222/255, green:225/255,blue:227/255, alpha: 1).cgColor
        stackView.backgroundColor = UIColor.red
        return stackView
    }()
    
//    private lazy var backgroundView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .purple
//        view.layer.cornerRadius = 10.0
//        return view
//    }()
    
//    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
//        view.translatesAutoresizingMaskIntoConstraints = false
//        stackView.insertSubview(view, at: 0)
//        view.pin(to: stackView)
//    }
    
    var goals: [Goal?] = []
    
    let fetchGoalsGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchGoalsGroup.enter()
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let uid = user.uid
                let db = Firestore.firestore()
                
                db.collection("users").document(uid).collection("goals").getDocuments { (snapshot, err) in
                    if let err = err {
                        print("Error fetching the goals: ", err)
                    } else {
                        self.goals = [Goal?](repeating: nil, count: snapshot!.documents.count)
                        var goalIndex = 0
                        for goal in snapshot!.documents {
                            let name = goal.get("name") as! String
                            let color = goal.get("color") as! String
                            let priority = goal.get("priority") as! Int

                            self.goals[goalIndex] = Goal(name: name, priority: priority, color: color)
                            goalIndex += 1
                        }
                        self.fetchGoalsGroup.leave()
                    }
                }
            }
        }

        self.fetchGoalsGroup.notify(queue: .main) {
            self.parentStackView.alignment = .center
            self.parentStackView.axis = .vertical
            self.parentStackView.distribution = .equalCentering
            self.parentStackView.spacing = 10
            
            print("goals2: ", self.goals)
            
            for goal in self.goals {
                if let unwrappedGoal = goal {
                    self.parentStackView.addArrangedSubview(self.childStackView)
                    self.parentStackView.backgroundColor = .black
                    self.childStackView.translatesAutoresizingMaskIntoConstraints = false
                    // self.childStackView.widthAnchor.constraint(equalTo: self.goalsScrollView.widthAnchor)
                    // self.childStackView.heightAnchor.constraint(equalToConstant: 30)
                    // self.childStackView.alignment = .fill
                    // self.childStackView.distribution = .fill
                    // self.childStackView.axis = .vertical
                    
                    let childTitle = UILabel()
                    childTitle.font = .preferredFont(forTextStyle: .body)
                    childTitle.backgroundColor = .orange
                    childTitle.translatesAutoresizingMaskIntoConstraints = false
                    
                    childTitle.text = "\(unwrappedGoal.name)"
                    
                    let childPriority = UILabel()
                    childPriority.text = "\(unwrappedGoal.priority)"
                    
                    self.childStackView.addArrangedSubview(childTitle)
                    self.childStackView.addArrangedSubview(childPriority)
                }
            }
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
