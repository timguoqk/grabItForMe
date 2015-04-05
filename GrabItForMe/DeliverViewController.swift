//
//  DeliverViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DeliverViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()

    override init() {
        super.init(nibName: "DeliverView", bundle: nil)
        
        navigationItem.title = "Deliver"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Buy", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("gotoBuy"))

        manager.requestWhenInUseAuthorization()
        manager.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uclaCoord = CLLocationCoordinate2DMake(34.0722, -118.4441)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(uclaCoord, 1000, 1000), animated: true)
        var option = UIBarButtonItem(title: "Options", style: UIBarButtonItemStyle.Plain, target: self, action: "gotoProfile")
        navigationItem.leftBarButtonItem = option
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if locations.count != 0 {
            let loc = locations[0] as CLLocation
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(loc.coordinate, 20, 20), animated: true)
        }
        
    }
    
    func gotoBuy() {
        var bvc = BuyMapViewController()
//        self.presentViewController(bvc, animated: true, completion: nil)
        navigationController?.pushViewController(bvc, animated: true)
    }
    
    func gotoOrder() {
        var pvc = PostViewController()
        navigationController?.pushViewController(pvc, animated: true)
    }
    
    func gotoProfile() {
        var ovc = ProfileTableViewController()
        navigationController?.pushViewController(ovc, animated:true)
    }

}
