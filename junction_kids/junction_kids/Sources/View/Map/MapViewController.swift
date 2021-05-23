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
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    @IBAction func currentCoordinateButton(_ sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    @IBOutlet weak var currentTextField: UITextField! {
        didSet {
            currentTextField.delegate = self
            currentTextField.clearButtonMode = .whileEditing
        }
    }
    @IBOutlet weak var destinationTextField: UITextField! {
        didSet {
            destinationTextField.delegate = self
            destinationTextField.clearButtonMode = .whileEditing
        }
    }
    
    @IBOutlet weak var searchView: UIView! {
        didSet {
            searchView.isHidden = true
        }
    }
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            searchTableView.delegate = self
            searchTableView.dataSource = self
            searchTableView.isHidden = true
        }
    }
    
    private var locationManager = CLLocationManager()
    private var currentLocation : CLLocation!
   
    private var startLocation = "" {
        didSet {
            currentTextField.text = startLocation
        }
    }
    private var endLocation: String = ""
    private var searchedItem : [MKMapItem] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        getCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 37.715133, 126.734086
    // 37.413294, 127.269311
    private func setUpMapView() {
        var sourceLocation : CLLocationCoordinate2D!
        
        guard let location = currentLocation else {return}
        sourceLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
  
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation)
        
        let sourceAnnotation = Pins()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
            sourceAnnotation.imageName = "currentpin"
        }
        
        findAddr(point: sourceAnnotation, lat: sourceLocation.latitude, long: sourceLocation.longitude)
        
        mapView.showAnnotations([sourceAnnotation], animated: true)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
  
    private func getCurrentLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: 권한 있음")
            currentLocation = locationManager.location
            print("currentlocation", currentLocation)
            setUpMapView()
        case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
        case .denied:
            print("GPS: 권한 없음")
        default:
            print("GPS: Default")
        }
    }
    
    private func zoomAndCenter(on centerCoordinate: CLLocationCoordinate2D, zoom: Double) {
        var span: MKCoordinateSpan = mapView.region.span
        span.latitudeDelta *= zoom
        span.longitudeDelta *= zoom
        
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: 위도, 경도에 따른 주소 찾기
    func findAddr(point: MKPointAnnotation, lat: CLLocationDegrees, long: CLLocationDegrees){
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en-US")
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: { [self](placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                var myAdd: String = "Now: "
                if let area: String = address.last?.locality{
                    myAdd += area
                }
                if let name: String = address.last?.name {
                    myAdd += " "
                    myAdd += name
                }
                point.title = myAdd
                startLocation = myAdd
            }
        })
    }
    
    private func searchRequest(_ text: String){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { response, _ in
            guard let result = response else { return }
            self.searchedItem = result.mapItems
            self.searchTableView.reloadData()
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pins")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pins")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        if let anno = annotation as? Pins {
            annotationView?.image = UIImage(named: anno.imageName)
        }
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManagr - failed,",error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager - update,",locations)
    }
    
    func presentNextVC(item: MKMapItem, index: Int) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: MapRecommendViewController.ViewID) as! MapRecommendViewController
        nextVC.mappableItem = MapItem(startPoint: currentLocation.coordinate, endPoint: item.placemark.coordinate, type: index)
        nextVC.startText = currentTextField.text!
        nextVC.endText = endLocation
        searchView.isHidden = true
        searchTableView.isHidden = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
}


extension MapViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else { return }
        if textField != currentTextField {
            endLocation = text
        }
        searchRequest(text)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchView.isHidden = true
        searchTableView.isHidden = true
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchView.isHidden = false
        searchTableView.isHidden = false
        return true
    }
}

extension MapViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MapSearchTableViewCell.CellID) as! MapSearchTableViewCell
        cell.bindViewModel(text: searchedItem[indexPath.row].name!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        endLocation = searchedItem[indexPath.row].name!
        presentNextVC(item: searchedItem[indexPath.row], index: -1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 60 : 240
    }
}
