//
//  YQRestaurantDetailViewController.swift
//  FoodPin
//
//  Created by yoferzhang on 2018/12/7.
//  Copyright © 2018 yoferzhang. All rights reserved.
//

// Swift 添加常量的方法
private struct Constants {
    static let nameLabelX: CGFloat = 12
    static let leftMarginOfRateButton: CGFloat = 15
}

import UIKit

class YQRestaurantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YQRestaurantReviewViewControllerDelegate {
    
    var restaurant: RestaurantMO!
    
    var detailTableView: UITableView!
    var headerView: UIImageView!
    var headerMaskView: UIView!
    var nameLabel: UILabel!
    var typeLabel: UILabel!
    var heartImageView: UIImageView!
    var ratingImageView: UIImageView!
    
    init(restaurant: RestaurantMO) {
        super.init(nibName: nil, bundle: nil)
        self.restaurant = restaurant
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        
        // Do any additional setup after loading the view.
        configNav()
        initDetailTableView()
        
    }
    
    func configNav() {
        navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        self.hidesBottomBarWhenPushed = true
    }
    
    func initDetailTableView() {
        detailTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.separatorStyle = .none
        detailTableView.register(YQRestaurantDetailIconTextCell.self, forCellReuseIdentifier: String(describing: YQRestaurantDetailIconTextCell.self))
        detailTableView.register(YQReataurantDetailTextCell.self, forCellReuseIdentifier: String(describing: YQReataurantDetailTextCell.self))
        detailTableView.register(YQRestaurantDetailMapCell.self, forCellReuseIdentifier: String(describing: YQRestaurantDetailMapCell.self))

        
        detailTableView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(detailTableView)
        
        self.initHeaderView()
        self.initFooterView()
    }
    
    func initHeaderView() {
        headerView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 350))
        headerView.contentMode = .scaleAspectFill
        if let restaurantImage = restaurant.image {
            headerView.image = UIImage(data: restaurantImage as Data)
        }
        headerView.layer.masksToBounds = true
        
        headerMaskView = UIView(frame: headerView.bounds)
        headerMaskView.backgroundColor = UIColor.black
        headerMaskView.alpha = 0.2
        headerView.addSubview(headerMaskView)
        
        
        typeLabel = UILabel(frame: CGRect.zero)
        typeLabel.font = UIFont.systemFont(ofSize: 13)
        typeLabel.text = restaurant.type
        typeLabel.textColor = UIColor.white
        typeLabel.layer.cornerRadius = 5.0
        typeLabel.layer.masksToBounds = true
        typeLabel.textAlignment = .center
        typeLabel.sizeToFit()
        typeLabel.backgroundColor = UIColor.orange
        typeLabel.frame = CGRect(x: Constants.nameLabelX, y: headerView.frame.height - 15 - typeLabel.frame.height, width: typeLabel.frame.width + 10, height: typeLabel.frame.height)
        headerView.addSubview(typeLabel)
        
        heartImageView = UIImageView(frame: CGRect(x: typeLabel.frame.maxX + 6, y: 0, width: 15, height: 15))
        heartImageView.image = UIImage(named: "heart-tick")
        heartImageView.center = CGPoint(x: heartImageView.center.x, y: typeLabel.center.y)
        headerView.addSubview(heartImageView)
        if restaurant.isVisited {
            heartImageView.isHidden = false
        } else {
            heartImageView.isHidden = true
        }
        
        nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 35)
        nameLabel.text = restaurant.name
        nameLabel.textColor = UIColor.white
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: Constants.nameLabelX, y: typeLabel.frame.origin.y - 6 - nameLabel.frame.height, width: headerView.frame.width - Constants.nameLabelX - Constants.nameLabelX, height: nameLabel.frame.height)
        headerView.addSubview(nameLabel)
        
        ratingImageView = UIImageView(frame: CGRect.zero)
        refreshRatingImageView(rateImage: restaurant.rating!)
        headerView.addSubview(ratingImageView)
        
        detailTableView.tableHeaderView = headerView
    }
    
    func initFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        
        let rateButton = UIButton(frame: CGRect(x: Constants.leftMarginOfRateButton, y: 0, width: footerView.frame.width - Constants.leftMarginOfRateButton * 2, height: 47))
        rateButton.center = CGPoint(x: rateButton.center.x, y: footerView.frame.height * 0.5)
        rateButton.setTitle("Rate it", for: .normal)
        rateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        rateButton.titleLabel?.textColor = .white
        rateButton.backgroundColor = .red
        rateButton.layer.masksToBounds = true
        rateButton.layer.cornerRadius = rateButton.frame.height * 0.5
        rateButton.addTarget(self, action: #selector(onClickRateButton), for: .touchUpInside)
        footerView.addSubview(rateButton)
        
        detailTableView.tableFooterView = footerView
    }
    
    // MARK: - tableViewDelegate & tableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: YQRestaurantDetailIconTextCell.self), for: indexPath) as! YQRestaurantDetailIconTextCell
            cell .setData(imageName: "phone", detailText: restaurant.phone!)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: YQRestaurantDetailIconTextCell.self), for: indexPath) as! YQRestaurantDetailIconTextCell
            cell .setData(imageName: "map", detailText: restaurant.location!)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: YQReataurantDetailTextCell.self), for: indexPath) as! YQReataurantDetailTextCell
            cell .setData(detailText: restaurant.summary!)
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: YQRestaurantDetailMapCell.self), for: indexPath) as! YQRestaurantDetailMapCell
            cell.configure(restaurant: restaurant)
            cell.selectionStyle = .none
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controoler")
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return YQRestaurantDetailIconTextCell.heightForIconTextCell(image: "photo", text: restaurant.phone!)
        case 1:
            return YQRestaurantDetailIconTextCell.heightForIconTextCell(image: "map", text: restaurant.location!)
        case 2:
            return YQReataurantDetailTextCell.heightForTextCell(restaurant: restaurant)
        case 3:
            return YQRestaurantDetailMapCell.heightForMapCell()
        default:
            fatalError("Failed to instantiate the table view cell for detail view controoler")
        }
    }
    
    /// 状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshRatingImageView(rateImage: String) {
        self.restaurant.rating = rateImage
        self.ratingImageView.image = UIImage(named: rateImage)
        self.ratingImageView.sizeToFit()
        self.ratingImageView.frame = CGRect(x: UIScreen.main.bounds.width - ratingImageView.frame.width, y: headerView.frame.height - ratingImageView.frame.height, width: ratingImageView.frame.width, height: ratingImageView.frame.height)
    }
    
    //MARK: - 点击事件
    @objc func onClickRateButton(recognizer: UITapGestureRecognizer) {
        let reviewVC = YQRestaurantReviewViewController()
        reviewVC.restaurant = restaurant
        reviewVC.delegate = self
        self.present(reviewVC, animated: true, completion: nil)
    }
    
    //MARK: - YQRestaurantReviewViewControllerDelegate
    func onClickRateButtonInReviewVC(rate: RateModel) {
        restaurant.rating = rate.image
        refreshRatingImageView(rateImage: rate.image)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
    }
    
}
