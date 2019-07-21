//
//  MapView.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import MapKit
import Foundation

class MapView: UIView, MKMapViewDelegate
{
    var mapView = MKMapView()
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var annotationTitle: String?
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        mapView.delegate = self
        if let theLat = lat
        {
             centerMap(location: CLLocation(latitude: theLat, longitude: long!))
        }else{
            let ran = Float.random(in: 0 ..< 1)
            self.lat = Double(37.7862002 + ran * 0.01)
            self.long = Double(-122.408004 + ran * 0.01)
        }
       
        addSubview(mapView)
    }
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("CALLED")
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        if let t = annotationTitle{
            annotation.title = t
        }
        mapView.addAnnotation(annotation)
        self.mapView.showAnnotations([annotation], animated: false)
    }
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        //dropPinZoomIn(lat: 37.7862002, long: -122.408004, titleString: "Start")
    }
    func centerMap(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
       
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
