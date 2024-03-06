//
//  ContentView.swift
//  UIKitMap
//
//  Created by Артём Черныш on 6.03.24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State
    private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.683318, longitude: -98.212695), span: MKCoordinateSpan(latitudeDelta: 23.1995166, longitudeDelta: 62.93747460000001))
    
    @State
    private var annotations: [Annotation] = [
        Annotation(id: 6, coordinate: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868)),
        Annotation(id: 7, coordinate: CLLocationCoordinate2D(latitude: 35.011286, longitude: -115.166868)),
        Annotation(id: 8, coordinate: CLLocationCoordinate2D(latitude: 40.712776, longitude: -74.005974)),
        Annotation(id: 9, coordinate: CLLocationCoordinate2D(latitude: 34.052235, longitude: -118.243683)),
        Annotation(id: 10, coordinate: CLLocationCoordinate2D(latitude: 41.878114, longitude: -87.629798)),
        Annotation(id: 11, coordinate: CLLocationCoordinate2D(latitude: 29.760427, longitude: -95.369804)),
        Annotation(id: 12, coordinate: CLLocationCoordinate2D(latitude: 33.748995, longitude: -84.387982)),
        Annotation(id: 13, coordinate: CLLocationCoordinate2D(latitude: 37.774929, longitude: -122.419416)),
        Annotation(id: 14, coordinate: CLLocationCoordinate2D(latitude: 47.606209, longitude: -122.332071)),
        Annotation(id: 15, coordinate: CLLocationCoordinate2D(latitude: 39.952583, longitude: -75.165222)),
        Annotation(id: 16, coordinate: CLLocationCoordinate2D(latitude: 36.167253, longitude: -115.148516)),
        Annotation(id: 17, coordinate: CLLocationCoordinate2D(latitude: 32.715738, longitude: -117.161084)),
        Annotation(id: 18, coordinate: CLLocationCoordinate2D(latitude: 35.501286, longitude: -115.166868))
    ]
    
    var body: some View {
        MapView(region: region, hideTrackingButton: true, annotations: annotations) { annotation in
            print(annotation.description)
        }
        .ignoresSafeArea()
        .onAppear {
            let coordinateRandomizer = CoordinateRandomizer()
            let points = coordinateRandomizer.generateRandomCoordinates(count: 5000, within: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.683318, longitude: -98.212695), span: MKCoordinateSpan(latitudeDelta: 200, longitudeDelta: 200)))
            let points2 = coordinateRandomizer.generateRandomCoordinates(count: 5000, within: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29, longitude: 81), span: MKCoordinateSpan(latitudeDelta: 200, longitudeDelta: 200)))
            var a = annotations.count
            for point in points {
                a += 1
                annotations.append(Annotation(id: a, coordinate: point))
            }
            for point in points2 {
                a += 1
                annotations.append(Annotation(id: a, coordinate: point))
            }
        }
    }
}

class Annotation: NSObject, MKAnnotation, Identifiable {
    init(id: Int, coordinate:CLLocationCoordinate2D) {
        self.id = id
        self.coordinate = coordinate
        super.init()
    }
    var coordinate: CLLocationCoordinate2D
    var id: Int
}
