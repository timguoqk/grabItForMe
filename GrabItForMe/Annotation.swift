//
//  Annotation.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import Foundation

import MapKit
 
class Place: NSObject, MKAnnotation {
  let title: String
  let locationName: String
  let discipline: String
  let coordinate: CLLocationCoordinate2D
 
  init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate
 
    super.init()
  }
 
  var subtitle: String {
    return locationName
  }
}