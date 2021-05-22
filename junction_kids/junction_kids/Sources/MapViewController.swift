//
//  MapViewController.swift
//  junction_kids
//
//  Created by 성다연 on 2021/05/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCurrentLocation()
        setUpMapView()
    }
   
    private func setUpMapView() {
        mapView.delegate = self
        
        // 37.715133, 126.734086
        // 37.413294, 127.269311
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: 37.561194, longitude: 127.037722)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "출발지"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "도착지"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        showRouteOnMap(coordinate: sourceLocation, destinationCoordinate: destinationLocation)
    }
    
    private func getCurrentLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        
        currentLocation = locationManager.location
    }
    
    func showRouteOnMap(coordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { [unowned self] response, error in
            guard let unWrappedResponse = response else { return }
            if let route = unWrappedResponse.routes.first {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: .init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .gray
        renderer.lineWidth = 5.0
        return renderer
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManagr - failed,",error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager - update,",locations)
    }
}
