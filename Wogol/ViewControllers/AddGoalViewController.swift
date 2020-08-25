//
//  AddGoalViewController.swift
//  Wogol
//
//  Created by Hernan Caceres on 8/3/20.
//  Copyright © 2020 HernanPeter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class AddGoalViewController: UIViewController {

    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var goalTextField: UITextField!
    
    @IBOutlet weak var submitGoalButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    //Sent to next View Controller so task/habits can be added as fields
    var finalGoalPath = ""
    
    func validateField(_ textfield:UITextField) -> String? {
        if textfield.text?.trimmingCharacters(in: .newlines) == "" {
            return "Error: Field is blank"
        }
        return nil
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func submitGoalTapped(_ sender: Any) {
        //Make sure fields aren't blank before submitting
        let error = validateField(goalTextField)
        if error != nil {
            showError(error!)
        }
        else {
            let goal = goalTextField.text!.trimmingCharacters(in: .newlines)
            finalGoalPath = goal
            
            let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    let uid = user.uid
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).collection("goals").document(goal).setData(["goal": goal])
                }
            }
            
        }
        
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let vc = segue.destination as! AddTask_HabitViewController
       vc.goalPath = finalGoalPath
   }

   
}
