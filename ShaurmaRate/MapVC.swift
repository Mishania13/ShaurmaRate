//
//  MapVC.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 02.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    var place = Place()
    let annotationIdentifire = "annotationIdentifire"
    let locationManager = CLLocationManager()
    let regionInMeters = 1000.0
    var incomeSegueIdentifire = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPinImage: UIButton!
    @IBOutlet weak var addresLable: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMapView()
        chekLocationServicies()
    }
    @IBAction func userLocationCenter() {
       showUserLocation()
    }
    @IBAction func CloseVC() {
        dismiss(animated: true)
    }
    @IBAction func doneButtonPressed () {
    }
    
    private func setupMapView() {
        if incomeSegueIdentifire == "showShawa" {
            addresLable.text = ""
            setupPlaceMark()
            mapPinImage.isHidden = true
            addresLable.isHidden = true
            doneButton.isHidden = true
        }
    }
    
    private func setupPlaceMark () {
        
         guard let location = place.location else { return }
              
              let geocoder = CLGeocoder()
              geocoder.geocodeAddressString(location) { (placemarks, error) in
                  
                  if let error = error {
                      print(error)
                      return
                  }
                  
                  guard let placemarks = placemarks else { return }
                  
                  let placemark = placemarks.first
                  
                  let annotation = MKPointAnnotation()
                  annotation.title = self.place.name
                  annotation.subtitle = self.place.price
                  
                  guard let placemarkLocation = placemark?.location else { return }
                  
                  annotation.coordinate = placemarkLocation.coordinate
                  
                  self.mapView.showAnnotations([annotation], animated: true)
                  self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func chekLocationServicies () {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuth()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let deniedAlert = UIAlertController(title: "Location Services are Disabled",
                                                    message: "Press OK to open setting",
                                                    preferredStyle: .alert)
                let accessAction = UIAlertAction(title: "OK", style: .default) {
                    (cAlertAction) in UIApplication.shared.open( URL(string:UIApplication.openSettingsURLString)!)
                }
                
                let cancleAction = UIAlertAction(title: "Cancle", style: .cancel)
                deniedAlert.addAction(accessAction)
                deniedAlert.addAction(cancleAction)
                
                self.present(deniedAlert, animated: true)
            }
        }
    }
    
    private func setupLocationManager () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuth () {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            
          mapView.showsUserLocation = true
            if incomeSegueIdentifire == "getAdress" { showUserLocation() }
            break
            
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let alert = UIAlertController(title: "Your Location is not Available",
                                              message: "To give permission Go to: Setting -> MyPlaces -> Location",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
            
        @unknown default: print("New case added")
        }
    }
    
    private func getCenterLocation(for mapView:MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func showUserLocation() {
      if let location = locationManager.location?.coordinate {
                   let region = MKCoordinateRegion(center: location,
                                                   latitudinalMeters: regionInMeters,
                                                   longitudinalMeters: regionInMeters)
                   mapView.setRegion(region, animated: true)
               }
    }
}

//MARK: - Map delegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annatationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: annotationIdentifire
            ) as? MKPinAnnotationView
        
        if annatationView == nil {
            annatationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifire)
            annatationView?.canShowCallout = true
            
        }
        if let imgData = place.imgData{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imgData)
            
            annatationView?.rightCalloutAccessoryView = imageView
        }
        return annatationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subLocality
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
            self.addresLable.text = "\(streetName!), \(buildNumber!) "
                } else if streetName != nil {
                     self.addresLable.text = "\(streetName!)"
                }
            }
        }
    }
    
}
//Mark: - Location delegate
extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
}
