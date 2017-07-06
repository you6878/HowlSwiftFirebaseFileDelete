//
//  ViewController.swift
//  HowlFireBaseLogin
//
//  Created by 유명식 on 2017. 6. 9..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit


class ViewController: UIViewController,GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error!) {
        if(result?.token == nil){
            return
        }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                // ...
                return
            }
        }
        FBSDKLoginManager().logOut();
        
    }

    @IBAction func signIn(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    @IBAction func signin(_ sender: Any) {
    
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!) { (user, error) in
         
            
            if(error != nil){
            
                FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                    // ...
                }
            
            }else{
                
                let alert = UIAlertController(title: "알림", message: "회원가입완료", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
            
            
            
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        facebookLoginButton.delegate = self
        
        FIRAuth.auth()?.addStateDidChangeListener({ (user, err) in
            if user != nil{
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

