//
//  Annotation.swift
//  HardSwiftUIMap
//
//  Created by Артём Черныш on 15.03.24.
//

import ClusterMap
import Combine
import MapKit
import SwiftUI

struct Annotation: Identifiable, CoordinateIdentifiable, Hashable {
    enum Style: Hashable {
        case single
        case cluster(annotations: [Annotation])
    }

    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var style: Style = .single
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == rhs.center && lhs.span.longitudeDelta == rhs.span.longitudeDelta && lhs.span.latitudeDelta == rhs.span.latitudeDelta
    }
}
