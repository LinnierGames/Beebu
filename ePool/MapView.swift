//
//  MapView.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import MapKit
import Foundation

class MapView: UIViewController, MKMapViewDelegate
{
    var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        mapView.delegate = self
        centerMap(location: CLLocation(latitude: 37.7862002, longitude: -122.408004))
        self.view.addSubview(mapView)
        
    }
    
    func centerMap(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createRoute(sourcePlacemark: MKPlacemark, destinationPlacemark: MKPlacemark)
    {
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Start"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "End"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).withAlphaComponent(0.8)
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
