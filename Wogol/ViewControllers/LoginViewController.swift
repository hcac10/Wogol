//
//  LoginViewController.swift
//  Wogol
//
//  Created by Hernan Caceres on 7/26/20.
//  Copyright © 2020 HernanPeter. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
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
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        //Style Buttons
        Utilities.styleFilledButton(loginButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
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
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        //Validate Text Fields
        let error = validateFields()
        if error != nil{
            //Fields are wrong, show error message
            showError(error!)
        }
        else{   //Sign in the User
            
            //Create cleaned versions of data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result , error) in
                if error != nil {
                    self.showError("Invalid password")
                }
                else{
                    self.transitionToHome()
                }
            }
        }
    }
    
}
