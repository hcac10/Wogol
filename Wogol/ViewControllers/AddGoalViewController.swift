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

//    @IBOutlet weak var goalLabel: UILabel!
//
//    @IBOutlet weak var goalTextField: UITextField!
//
//    @IBOutlet weak var submitGoalButton: UIButton!
//
//    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var priorityPickerField: UISegmentedControl!
    
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func validateField(_ textfield:UITextField) -> String? {
        if textfield.text?.trimmingCharacters(in: .newlines) == "" {
            return "Error: Field is blank"
        }
        return nil
    }
    
    @IBAction func createGoalTapped(_ sender: Any) {
        //Make sure fields aren't blank before submitting
        let error = validateField(nameTextField)
        if error != nil {
            print(error ?? "")
//            showError(error!)
        }
        else {
            let name = nameTextField.text!.trimmingCharacters(in: .newlines)
            let color = colorTextField.text!.trimmingCharacters(in: .newlines)
            let priority = Int(priorityPickerField.titleForSegment( at: priorityPickerField.selectedSegmentIndex) ?? "")
            
            _ = Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    let uid = user.uid
                    let db = Firestore.firestore()                    
                    db.collection("users").document(uid).collection("goals").addDocument(data: ["name": name, "color": color, "priority": priority!]) { (error) in
                        if error != nil {
                            // There was an error, show error message
                            print("Error saving user data")
                        }
                    }
                }
            }
        }
    }
    
    
    
//    func showError(_ message: String){
//        errorLabel.text = message
//        errorLabel.alpha = 1
//    }
    
//    @IBAction func submitGoalTapped(_ sender: Any) {
//        //Make sure fields aren't blank before submitting
//        let error = validateField(goalTextField)
//        if error != nil {
//            showError(error!)
//        }
//        else {
//            let goal = goalTextField.text!.trimmingCharacters(in: .newlines)
//            finalGoalPath = goal
//
//            let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//                if let user = user {
//                    let uid = user.uid
//                    let db = Firestore.firestore()
//                    db.collection("users").document(uid).collection("goals").document(goal).setData(["goal": goal])
//                }
//            }
//        }
//
//    }
    
//   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       let vc = segue.destination as! AddTask_HabitViewController
//       vc.goalPath = finalGoalPath
//   }

   
}
