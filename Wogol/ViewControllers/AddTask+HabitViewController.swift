//
//  AddTask+HabitViewController.swift
//  Wogol
//
//  Created by Hernan Caceres on 8/3/20.
//  Copyright © 2020 HernanPeter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddTask_HabitViewController: UIViewController {

    @IBOutlet weak var tasksLabel: UILabel!
    
    @IBOutlet weak var tasksTextField: UITextField!
    
    @IBOutlet weak var taskButton: UIButton!
    
    @IBOutlet weak var habitsLabel: UILabel!
    
    @IBOutlet weak var habitsTextField: UITextField!
    
    @IBOutlet weak var habitButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var goalPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
    
    func transitionToTasks(){
        
        let tasksViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tasksViewController)
        
        view.window?.rootViewController = tasksViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func submitTaskPressed(_ sender: Any) {
        //Make sure fields aren't blank before submitting
        let error = validateField(tasksTextField)
        if error != nil {
            showError(error!)
        }
        else {
            //Store task
            let task = tasksTextField.text!.trimmingCharacters(in: .newlines)
            let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    let uid = user.uid
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).collection("goals").document(self.goalPath).setData(["task": task], merge:true)                }
            }
            
            //Reset field
            tasksTextField.placeholder = "Enter other tasks if neccessary"
            tasksTextField.text = ""
        }

    }
    
    @IBAction func submitHabitPressed(_ sender: Any) {
        let error = validateField(habitsTextField)
        if error != nil {
            showError(error!)
        }
        else {
            //Store habit
            let habit = habitsTextField.text!.trimmingCharacters(in: .newlines)
            let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    let uid = user.uid
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).collection("goals").document(self.goalPath).setData(["habit": habit])
                }
            }
            
            //Reset field
            habitsTextField.placeholder = "Enter other tasks if neccessary"
            habitsTextField.text = ""
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        transitionToTasks()
    }
    
    
    
}
