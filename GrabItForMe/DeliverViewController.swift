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
    var myRoute : MKRoute?
    
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
        
        let Crab = Place(title: "The Boiling Crab",
            locationName: "10875 Kinross Ave",
            discipline: "Seafood",
            coordinate: CLLocationCoordinate2D(latitude: 34.061086, longitude: -118.444705))
        
        mapView.addAnnotation(Crab)
        
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
        
        // routing example
        var point1 = MKPointAnnotation()
        var point2 = MKPointAnnotation()
        
        point1.coordinate = CLLocationCoordinate2DMake(34.063039, -118.446819)
        point1.title = "Diddy Riese"
        point1.subtitle = "Dessert"
        mapView.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(34.068936, -118.443212)
        point2.title = "Home"
        point2.subtitle = "UCLA"
        mapView.addAnnotation(point2)
        mapView.centerCoordinate = point2.coordinate
        mapView.delegate = self
        
        var directionsRequest = MKDirectionsRequest()
        let markPlace = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let markHome = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.setSource(MKMapItem(placemark: markPlace))
        directionsRequest.setDestination(MKMapItem(placemark: markHome))
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        var directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
            if error == nil {
                self.myRoute = response.routes[0] as? MKRoute
                self.mapView.addOverlay(self.myRoute?.polyline)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        var myLineRenderer = MKPolylineRenderer(polyline: myRoute?.polyline!)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
/*        var origin = "UCLA"
        var destination =  "Diddy Riese"
        
        var mapManager = MapManager()
        mapManager.directionsUsingGoogle(from: origin, to: destination) { (route, directionInformation, boundingRegion, error) -> () in
            
            if(error != nil){
                
                println(error!)
            }else{
                
                if let web = self.mapView?{
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        web.addOverlay(route!)
                        web.setVisibleMapRect(boundingRegion!, animated: true)
                    }
                    
                }
                
            }
        }
        var latOrigin = 34.0598619
        var lngOrigin = -118.444444
        var coordinateOrigin = CLLocationCoordinate2D(latitude: latOrigin, longitude: lngOrigin)
        var latDestination = 34.068936
        var lngDestination = -118.443212
        var coordinateDestination = CLLocationCoordinate2D(latitude: latDestination, longitude: lngDestination)
        
        mapManager.directions(from: coordinateOrigin, to: coordinateDestination) { (route, directionInformation, boundingRegion, error) -> () in
            
            if (error? != nil) {
                
                println(error!)
            }else{
                
                if let web = self.mapView?{
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        web.addOverlay(route!)
                        web.setVisibleMapRect(boundingRegion!, animated: true)
                        
                    }
                }
            }
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if locations.count != 0 {
            let loc = locations[0] as CLLocation
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(loc.coordinate, 20, 20), animated: true)
        }
        
    }*/
    
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
