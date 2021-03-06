//
//  YQRestaurantDetailMapCell.swift
//  FoodPin
//
//  Created by yoferzhang on 2018/12/13.
//  Copyright © 2018 yoferzhang. All rights reserved.
//

// Swift 添加常量的方法
private struct DetailMapCellConstants {
    static let leftMarginOfLabel: CGFloat = 12
    static let topMarginOfLabel: CGFloat = 10
    static let marginOfTitleAndSeparator: CGFloat = 6
    static let heightOfMapView: CGFloat = 215
}


import UIKit
import MapKit

class YQRestaurantDetailMapCell: UITableViewCell {

    var titleLabel: UILabel!
    var separatorView: UIView!
    var mapView: MKMapView!
    
    var restaurant: RestaurantMO!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() -> Void {
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = "HOW TO GET HERE"
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: DetailMapCellConstants.leftMarginOfLabel, y: DetailMapCellConstants.topMarginOfLabel, width: UIScreen.main.bounds.width - DetailMapCellConstants.leftMarginOfLabel * 2, height: titleLabel.frame.height)
        self.contentView.addSubview(titleLabel)
        
        separatorView = UIView(frame: CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.maxY + DetailMapCellConstants.marginOfTitleAndSeparator, width: UIScreen.main.bounds.width - DetailMapCellConstants.leftMarginOfLabel * 2, height: 0.5))
        separatorView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(separatorView)
        
        mapView = MKMapView(frame: CGRect(x: 0, y: separatorView.frame.maxY + DetailMapCellConstants.marginOfTitleAndSeparator, width: UIScreen.main.bounds.width, height: DetailMapCellConstants.heightOfMapView))
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isZoomEnabled = false
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickMapView)))
        self.contentView.addSubview(mapView)
    }
    
    @objc func onClickMapView(recognizer: UITapGestureRecognizer) {
        let mapVC = YQRestaurantMapViewController()
        mapVC.restaurant = restaurant
        self.currentViewController()?.present(mapVC, animated: true, completion: nil)
    }
    
    func configure(restaurant: RestaurantMO) {
        self.restaurant = restaurant
        let geoCoder = CLGeocoder()
        
        print(restaurant.location!)
        
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: {placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                // Add annnotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        })
    }
    
    // MARK: - Helper Method
    func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    /// 类方法返回cell的高
    class func heightForMapCell() -> CGFloat {
        var height: CGFloat = 0
        
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = "HOW TO GET HERE"
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: DetailMapCellConstants.leftMarginOfLabel, y: DetailMapCellConstants.topMarginOfLabel, width: UIScreen.main.bounds.width - DetailMapCellConstants.leftMarginOfLabel * 2, height: titleLabel.frame.height)
        height = titleLabel.frame.maxY + DetailMapCellConstants.marginOfTitleAndSeparator * 2 + 0.5 + DetailMapCellConstants.heightOfMapView + 12
        
        return height
    }
    
}
