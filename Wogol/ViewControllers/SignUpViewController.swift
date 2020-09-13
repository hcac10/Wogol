//
//  SignUpViewController.swift
//  Wogol
//
//  Created by Hernan Caceres on 7/26/20.
//  Copyright © 2020 HernanPeter. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements() {
        
        //Hide error label
        errorLabel.alpha = 0
        
        //Style Text Fields
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        //Style Buttons
        Utilities.styleFilledButton(signUpButton)

    }

    
    
    /* Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, returns error message. */
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        //Check if password is secure ***Note: Email Check documentation available**
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false{
            
            return "Please make sure password has at least 8 characters, and contains one special character and one number"
        }
        
        return nil
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        let homeVC = storyboard?.instantiateViewController(identifier: "homeViewController") as? UITabBarController
        
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
        
    @IBAction func signUpTapped(_ sender: Any) {
        //Validate the fields
        let error = validateFields()
        if error != nil{
            //Fields are wrong, show error message
            showError(error!)
        }
        else{
            //Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            //Create the User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors creating user
                if err != nil{
                    //There was an error creating the user
                    self.showError("Error creating user")
                }
                else{
                    //User was created successfully, store first and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData(["firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            //There was an error, show error message
                            self.showError("Error saving user data")
                        }

                    }
                    self.transitionToHome()
                    }
            }
            }
    
    }
}
