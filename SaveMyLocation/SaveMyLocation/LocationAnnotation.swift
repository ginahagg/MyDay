//
//  LocationAnnotation.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 5/30/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let photoUrl : String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, photoUrl: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.photoUrl = photoUrl
        super.init()
    }
    
}
