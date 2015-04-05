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
        
        navigationItem.title = "Explore - Deliver"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Buy", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("gotoBuy"))

        manager.requestWhenInUseAuthorization()
        manager.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uclaCoord = CLLocationCoordinate2DMake(34.068936, -118.443212)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(uclaCoord, 1000, 1000), animated: true)
        var option = UIBarButtonItem(title: "Options", style: UIBarButtonItemStyle.Plain, target: self, action: "gotoProfile")
        navigationItem.leftBarButtonItem = option
        
        // show places on map
        let DiddyRiese = Place(title: "Diddy Riese",
            locationName: "926 Broxton Ave",
            discipline: "Dessert",
            coordinate: CLLocationCoordinate2D(latitude: 34.063039, longitude: -118.446819))
        
        mapView.addAnnotation(DiddyRiese)
        
        let Degrees = Place(title: "800 Degrees Neapolitan Pizzeria",
            locationName: "10889 Lindbrook Dr",
            discipline: "Pizza",
            coordinate: CLLocationCoordinate2D(latitude: 34.0598619, longitude: -118.444444))
        
        mapView.addAnnotation(Degrees)
        
        let InNOut = Place(title: "In-N-Out Burger",
            locationName: "922 Gayley Ave",
            discipline: "Fast Food",
            coordinate: CLLocationCoordinate2D(latitude: 34.063077, longitude: -118.448031))
        
        mapView.addAnnotation(InNOut)
        
        let Gushi = Place(title: "Gushi",
            locationName: "978 Gayley Ave",
            discipline: "Korean",
            coordinate: CLLocationCoordinate2D(latitude: 34.062301, longitude: -118.447871))
        
        mapView.addAnnotation(Gushi)
        
        let WholeFoods = Place(title: "Whole Foods Market",
            locationName: "1050 Gayley Ave",
            discipline: "Supermarket",
            coordinate: CLLocationCoordinate2D(latitude: 34.061217, longitude: -118.446906))
        
        mapView.addAnnotation(WholeFoods)
        
        let Ralphs = Place(title: "Ralphs",
            locationName: "10861 Le Conte",
            discipline: "Supermarket",
            coordinate: CLLocationCoordinate2D(latitude: 34.063299, longitude: -118.443998))
        
        mapView.addAnnotation(Ralphs)
        
        let Trader = Place(title: "Trader Joe's",
            locationName: "1000 Glendon Ave",
            discipline: "Supermarket",
            coordinate: CLLocationCoordinate2D(latitude: 34.062539, longitude: -118.443982))
        
        mapView.addAnnotation(Trader)

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
