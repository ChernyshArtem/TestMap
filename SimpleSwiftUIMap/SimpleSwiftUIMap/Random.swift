//
//  Random.swift
//  TestMap
//
//  Created by Артём Черныш on 2.03.24.
//

import MapKit

extension MKCoordinateRegion {
    var maxLongitude: CLLocationDegrees { center.longitude + span.longitudeDelta / 2 }
    var minLongitude: CLLocationDegrees { center.longitude - span.longitudeDelta / 2 }
    var maxLatitude: CLLocationDegrees { center.latitude + span.latitudeDelta / 2 }
    var minLatitude: CLLocationDegrees { center.latitude - span.latitudeDelta / 2 }
}

extension MKCoordinateRegion {
    func randomCoordinate() -> CLLocationCoordinate2D {
        .random(
            minLatitude: minLatitude,
            maxLatitude: maxLatitude,
            minLongitude: minLongitude,
            maxLongitude: maxLongitude
        )
    }
}

public struct CoordinateRandomizer {
    public init() { }

    public func generateRandomCoordinates(count: Int, within region: MKCoordinateRegion) -> [CLLocationCoordinate2D] {
        (0..<count).map { _ in
            region.randomCoordinate()
        }
    }
}

extension CLLocationCoordinate2D {
    static func random(
        minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) -> CLLocationCoordinate2D {
        let latitudeDelta = maxLatitude - minLatitude
        let longitudeDelta = maxLongitude - minLongitude

        let latitude = minLatitude + latitudeDelta * Double.random(in: 0...1)
        let longitude = minLongitude + longitudeDelta * Double.random(in: 0...1)

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

