//
//  ContentView.swift
//  HardSwiftUIMap
//
//  Created by Артём Черныш on 22.02.24.
//

import ClusterMap
import Combine
import MapKit
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        LegacyMap(objects: .constant([
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 35.011_286, longitude: -115.166_868)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 40.712776, longitude: -74.005974)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 34.052235, longitude: -118.243683)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 41.878114, longitude: -87.629798)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 29.760427, longitude: -95.369804)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 33.748995, longitude: -84.387982)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 37.774929, longitude: -122.419416)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 47.606209, longitude: -122.332071)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 39.952583, longitude: -75.165222)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 36.167253, longitude: -115.148516)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 32.715738, longitude: -117.161084)),
            Annotation(coordinate: CLLocationCoordinate2D(latitude: 35.501_286, longitude: -115.166_868))
        ]))
    }
}

#Preview {
    ContentView()
}
