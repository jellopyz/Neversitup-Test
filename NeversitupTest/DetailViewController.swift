//
//  DetailViewController.swift
//  NeversitupTest
//
//  Created by Thanakorn Amnajsatit on 18/6/2563 BE.
//  Copyright © 2563 GAS. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: premiumLabel.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        premiumLabel.layer.mask = maskLayer
    }

}
