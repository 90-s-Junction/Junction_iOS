//
//  ViewController.swift
//  junction_kids
//
//  Created by 성다연 on 2021/05/22.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView = GMSMapView()
    var marker = GMSMarker()
    let locationManager = CLLocationManager()
    let geocoder = GMSGeocoder()
    
    // 위도 경도
    var origin_latitude: CLLocationDegrees = 0.0
    var origin_longitude: CLLocationDegrees = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLocationManager()
        getCordinates("Seoul")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGoogleMap()
        callCurrentGPS()
        // Do any additional setup after loading the view.
    }

    private func setUpGoogleMap(){
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    private func setUpLocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func getCordinates(_ locationName: String){
        CLGeocoder().geocodeAddressString(locationName, completionHandler: { (placeMark, error) in
            if error != nil {
                print(error)
                return
            }
            if let place = placeMark, let location = place[0].location {
                let coordinate = location.coordinate
                // 위도와 경도
                self.origin_latitude = coordinate.latitude
                self.origin_longitude = coordinate.longitude
            }
        })
    }

    private func callCurrentGPS(){
//        if let cor = locationManager.location {
            let camera = GMSCameraPosition.camera(withLatitude: origin_latitude, longitude: origin_longitude, zoom: 16)
//            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 13.8)
            mapView.camera = camera
            mapView.settings.myLocationButton = true
            mapView.mapType = .normal
            mapView.isMyLocationEnabled = true
            mapView.delegate = self

//        }
    }
    // 맵을 계속 움직일 때 호출
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapView.clear()
    }
    
    // 이동을 끝낸 후 호출
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("이동 :",position.target.latitude)
        geocoder.reverseGeocodeCoordinate(position.target, completionHandler: { (responose, error) in
            guard error == nil else {return}
            if let r = responose, let result = r.firstResult() {
                let marker = GMSMarker()
                marker.position = position.target
                marker.title = result.lines?[0]
                marker.snippet = result.lines?[1]
                marker.map = mapView
            }
        })
    }
}

