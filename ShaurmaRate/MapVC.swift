//
//  MapVC.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 02.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    var place: Place!

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func CloseVC() {
        dismiss(animated: true)
    }

}
