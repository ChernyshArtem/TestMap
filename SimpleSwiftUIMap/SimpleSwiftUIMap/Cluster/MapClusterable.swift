import MapKit

public protocol MapClusterable: Clusterable {
    associatedtype ID: Hashable
    var id: ID { get }
    var location: CLLocationCoordinate2D { get }
}

extension MapClusterable {
    
    public func distance(to other: Self) -> Double {
        let selfLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let otherLocation = CLLocation(latitude: other.location.latitude, longitude: other.location.longitude)
        let distance = selfLocation.distance(from: otherLocation)
        return distance
    }
    
}

extension Array where Element: MapClusterable {
    
    public func clusterize(distance: Double) -> [MapCluster<Element>] {
        return clusterize(distance: distance).enumerated().map { (id, values) in
            MapCluster(values: values)
        }
    }
    
    public func clusterize(region: MKCoordinateRegion, factor: Double = 50) -> [MapCluster<Element>] {
        var minSpan = CLLocation(latitude: region.center.latitude - region.span.latitudeDelta, longitude: region.center.longitude)
        var maxSpan = CLLocation(latitude: region.center.latitude + region.span.latitudeDelta, longitude: region.center.longitude)
        if minSpan.coordinate.latitude < -90 {
            minSpan = CLLocation(latitude: -90, longitude: region.center.longitude)
        }
        if maxSpan.coordinate.latitude > 90 {
            maxSpan = CLLocation(latitude: 90, longitude: region.center.longitude)
        }
        let newMapSpanDistance = minSpan.distance(from: maxSpan)
        return clusterize(distance: newMapSpanDistance/factor).enumerated().map { (id, values) in
            MapCluster(values: values)
        }
    }
    
}
