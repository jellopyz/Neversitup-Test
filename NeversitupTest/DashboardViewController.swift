//
//  DashboardViewController.swift
//  NeversitupTest
//
//  Created by Thanakorn Amnajsatit on 18/6/2563 BE.
//  Copyright © 2563 GAS. All rights reserved.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    let customers = UserDefaults.standard.array(forKey: "customers")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBtn.layer.masksToBounds = true
        logoutBtn.layer.cornerRadius = 10
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        
        UserDefaults.standard.set(nil, forKey: "apiToken")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard customers != nil else {
            return 0
        }
        return customers?.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as! DashboardTableViewCell
        if let customers = customers {
            let singleCustomer = customers[indexPath.row] as! Dictionary<String, String>
            cell.nameLabel.text = singleCustomer["name"]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let customers = customers,
            let token = UserDefaults.standard.string(forKey: "apiToken") else {
                return
        }
        let singleCustomer = customers[indexPath.row] as! Dictionary<String, String>
        
        let params: [String: Any] = [
            "token": token,
            "customerId": singleCustomer["id"] ?? ""
        ]
        
        AF.request("http://boomkorn.pythonanywhere.com/getCustomerDetail", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = result as! Dictionary<String, Any>
                let data = json["data"] as! Dictionary<String, Any>
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.view.layoutIfNeeded()
                vc.nameLabel.text = data["name"] as? String ?? ""
                vc.gradeLabel.text = data["customerGrade"] as? String ?? ""
                vc.sexLabel.text = data["sex"] as? String ?? ""
                if data["isCustomerPremium"] as? Int != 0 {
                    vc.premiumLabel.isHidden.toggle()
                }
                self.present(vc, animated: true, completion: nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
