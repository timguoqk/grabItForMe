//
//  BuyViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BuyMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    
    override init() {
        super.init(nibName: "BuyMapView", bundle: nil)
        
        navigationItem.title = "Buy"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Deliver", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("gotoDeliver"))
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.Hybrid
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        
        let uclaCoord = CLLocationCoordinate2DMake(34.0722, -118.4441)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(uclaCoord, 1000, 1000), animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if locations.count != 0 {
            let loc = locations[0] as CLLocation
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(loc.coordinate, 20, 20), animated: true)
        }
        
    }
    
    func gotoDeliver() {
        var dvc = DeliverViewController()
//        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
//        self.modalPresentationStyle = .FullScreen
//        self.presentViewController(dvc, animated: true, completion: nil)
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func gotoOrder() {
        var pvc = PostViewController()
        navigationController?.pushViewController(pvc, animated: true)
    }
}
