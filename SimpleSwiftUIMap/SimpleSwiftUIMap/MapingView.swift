//
//  MapingView.swift
//  TestMap
//
//  Created by Артём Черныш on 6.03.24.
//

import SwiftUI
import MapKit

struct MapingView: View {
    
    @State
    var places: [Place]
        
    @State 
    private var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
        
    var body: some View {
        MapClusterizer(coordinateRegion: $coordinateRegion, clusterables: places) { (clusters, proxy) in
            Map(coordinateRegion: $coordinateRegion, annotationItems: clusters) { cluster in
                MapAnnotation(coordinate: cluster.center) {
                    ClusterView(cluster: cluster) {
                        withAnimation {
                            proxy.zoom(on: cluster)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            //coordinateRegion = findCenterRegion(places: places)
        }
    }
    
    private func findCenterRegion(places: [Place]) -> MKCoordinateRegion {
        let minLat = places.max { firstAnnotation, secondAnnotation in
            firstAnnotation.location.latitude > secondAnnotation.location.latitude
        }?.location.latitude ?? 0
        let maxLat = places.max { firstAnnotation, secondAnnotation in
            firstAnnotation.location.latitude < secondAnnotation.location.latitude
        }?.location.latitude ?? 0
        let minLong = places.max { firstAnnotation, secondAnnotation in
            firstAnnotation.location.longitude > secondAnnotation.location.longitude
        }?.location.longitude ?? 0
        let maxLong = places.max { firstAnnotation, secondAnnotation in
            firstAnnotation.location.longitude < secondAnnotation.location.longitude
        }?.location.longitude ?? 0
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (maxLat + minLat) / 2, longitude: (maxLong + minLong) / 2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3, longitudeDelta: (maxLong - minLong) * 1.3))
    }
}
