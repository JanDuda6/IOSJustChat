//
//  ViewController.swift
//  IOSChat
//
//  Created by Kurs on 19/10/2020.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase

class WelcomeVC: KeyboardHandlerVC {
    let userService = UserService()
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var facebookButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func googleButtonPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }

    @IBAction func facebookButtonPushed(_ sender: UIButton) {
        loginWithFacebook()
    }

    @IBAction func logInButtonPushed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                if let error = error {
                    AlertHandler.errorHandler(view: self, error: error)
                } else {
                    self.performSegue(withIdentifier: Constant.SegueIdentifier.loggedVC, sender: self)
                }
            }
        }
    }
}
//MARK: - Google SignIn
extension WelcomeVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            AlertHandler.errorHandler(view: self, error: error)
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBSaveError): \(error.localizedDescription)")
                } else {
                    let userEmail = result?.user.email
                    let userID = result?.user.uid
                    let userDisplayName = result?.user.displayName
                    self.userService.addUserToDB(userName: userDisplayName!, userEmail: userEmail!, userID: userID!)
                    self.performSegue(withIdentifier: Constant.SegueIdentifier.loggedVC, sender: self)
                }
            }
        }
    }
}
// MARK: Create User from form
extension WelcomeVC {
    @IBAction func createUserButtonPushed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                if let error = error {
                    AlertHandler.errorHandler(view: self, error: error)
                } else {
                    let displayName = loginTextField.text ?? nil
                    let userID = authResult?.user.uid
                    self.userService.addUserToDB(userName: displayName!, userEmail: email, userID: userID!)
                    self.performSegue(withIdentifier: Constant.SegueIdentifier.loggedVC, sender: self)
                }
            }
        }
    }
}

//MARK: - Sign in with Facebook
extension WelcomeVC {
    func loginWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile, email"], from: self) { (result, error) in
            if let error = error {
                print("\(Constant.ErrorDescription.LogInError): \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else { return }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBSaveError): \(error)")
                } else {
                    let userEmail = result?.user.email
                    let userID = result?.user.uid
                    let userDisplayName = result?.user.displayName
                    self.userService.addUserToDB(userName: userDisplayName!, userEmail: userEmail!, userID: userID!)
                    self.performSegue(withIdentifier: Constant.SegueIdentifier.loggedVC, sender: self)
                }
            }
        }
    }
}
