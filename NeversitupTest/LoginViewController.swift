//
//  LoginViewController.swift
//  NeversitupTest
//
//  Created by Thanakorn Amnajsatit on 18/6/2563 BE.
//  Copyright © 2563 GAS. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        let params: [String: Any] = [
            "username": usernameTF.text!,
            "password": passwordTF.text!
        ]
        AF.request("http://boomkorn.pythonanywhere.com/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = data as! Dictionary<String, Any>
                print(json)
                UserDefaults.standard.set(json["token"], forKey: "apiToken")
                UserDefaults.standard.set(json["customers"], forKey: "customers")
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                if let nextViewController = storyboard.instantiateViewController(identifier: "DashboardViewController") as? DashboardViewController {
                    nextViewController.modalPresentationStyle = .overFullScreen
                    self.present(nextViewController, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
}
