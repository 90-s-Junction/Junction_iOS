//
//  VideoViewController.swift
//  junction_kids
//
//  Created by 홍정민 on 2021/05/22.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation
import AVKit

class VideoViewController: UIViewController, MKMapViewDelegate {
   
    //Starting a Simulation Btn Event
    @IBAction func playVideo(_ sender: UIButton) {
        showVideo()
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    //Route Info View Elements
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dayImageView: UIImageView!
    @IBOutlet weak var playVideoBtn: UIButton!
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    static let ViewID = "VideoViewController"
    
    //Variable for API
    var mapItem : MapItem!
    var videoURL:String = ""
    var startText = ""
    var endText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()
        setUpMapView()
    }
    
    private func setUpSubViews(){
        navigationController?.navigationBar.isHidden = true
        infoView.layer.cornerRadius = 10
        playVideoBtn.layer.cornerRadius = 10
        
        let selectedRoute = RouteFactory.shared[mapItem.type]
        
        DispatchQueue.main.async { [weak self] in
            self?.dayImageView.image = UIImage(named: selectedRoute.dayNight.image())
        }
        
        typeLabel.text = selectedRoute.carType
        timeLabel.text = "\(selectedRoute.time)min"
        distanceLabel.text = "\(selectedRoute.distance)km"
    }


    private func getVideoURL(){
        VideoService.shared.getVideo(startX: Float(mapItem.startPoint.latitude),
                                     startY: Float(mapItem.startPoint.longitude),
                                     endX: Float(mapItem.endPoint.latitude),
                                     endY: Float(mapItem.endPoint.longitude),
                                     type: mapItem.type, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    print("status =",status)
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let result = try? decoder.decode(VideoResult.self, from: data)
                    guard let url = result?.videoURL else { return }
                    self.videoURL = url
                    self.showVideo()
                    break
                case 401...404:
                    break
                case 500:
                    break
                default:
                    return
                }
            }
        })
    }
    
    private func showVideo(){
        guard let url = URL(string: "http://49.50.162.246:443/test") else {
            return
        }
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)

        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player

        // Modally present the player and call the player's play() method when compl ete.
        present(controller, animated: true) {
            player.play()
        }
    }
    
    
    // MARK: Setting Map Kit
    
    private func setUpMapView() {
        let sourcePlacemark = MKPlacemark(coordinate: mapItem.startPoint)
        let destinationPlacemark = MKPlacemark(coordinate: mapItem.endPoint)
        
        let sourceAnnotation = Pins()
        
        let destinationAnnotation = Pins()
        if let Slocation = sourcePlacemark.location,
           let Dlocation = destinationPlacemark.location {
            sourceAnnotation.coordinate = Slocation.coordinate
            sourceAnnotation.imageName = "handliticon" 
            destinationAnnotation.coordinate = Dlocation.coordinate
            destinationAnnotation.imageName = "currentpin"
        }
        
        mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        showRouteOnMap(coordinate: mapItem.startPoint, destinationCoordinate: mapItem.endPoint)
    }

    private func showRouteOnMap(coordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { [weak self] response, error in
            guard let unWrappedResponse = response else { return }
            if let route = unWrappedResponse.routes.first {
                self?.mapView.addOverlay(route.polyline)
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: .init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .leafgreen
        renderer.lineWidth = 5.0
        return renderer
    }
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pins")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pins")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let anno = annotation as! Pins
        annotationView?.image = UIImage(named: anno.imageName)
        
        return annotationView
    }
}
