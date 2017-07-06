//
//  UserController.swift
//  HowlFireBaseLogin
//
//  Created by 유명식 on 2017. 6. 17..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class UserController: UIViewController {

    @IBAction func logout(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch  {
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
