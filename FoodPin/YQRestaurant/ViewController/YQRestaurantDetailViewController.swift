//
//  YQRestaurantDetailViewController.swift
//  FoodPin
//
//  Created by yoferzhang on 2018/12/7.
//  Copyright © 2018 yoferzhang. All rights reserved.
//

import UIKit

class YQRestaurantDetailViewController: UIViewController {

    var restaurantName = ""
    var restaurantImageName = ""
    var restaurantLocation = ""
    var restaurantType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
        initializeView()
    }
    
    func initializeView() {
        let restaurantImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        restaurantImageView.image = UIImage(named: restaurantImageName)
        restaurantImageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(restaurantImageView)
        
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.text = restaurantImageName
        nameLabel.sizeToFit()
        nameLabel.center = CGPoint(x: view.bounds.width * 0.5, y: restaurantImageView.center.y - 30)
        view.addSubview(nameLabel)
        
        let locationLabel = UILabel(frame: CGRect.zero)
        locationLabel.text = restaurantLocation
        locationLabel.sizeToFit()
        locationLabel.center = CGPoint(x: view.bounds.width * 0.5, y: 0)
        locationLabel.frame = CGRect(x: locationLabel.frame.origin.x, y: nameLabel.frame.maxY + 5, width: locationLabel.frame.width, height: locationLabel.frame.height)
        view.addSubview(locationLabel)
        
        let typeLabel = UILabel(frame: CGRect.zero)
        typeLabel.text = restaurantType
        typeLabel.sizeToFit()
        typeLabel.center = CGPoint(x: view.bounds.width * 0.5, y: 0)
        typeLabel.frame = CGRect(x: typeLabel.frame.origin.x, y: locationLabel.frame.maxY + 5, width: typeLabel.frame.width, height: typeLabel.frame.height)
        view.addSubview(typeLabel)
        
        //试试
    }
    

}
