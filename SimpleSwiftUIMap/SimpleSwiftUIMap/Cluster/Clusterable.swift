import Foundation
import MapKit

public protocol Clusterable: Equatable {
    func distance(to other: Self) -> Double
}

extension Array where Element: Clusterable {
    
    public func clusterize(distance: Double) -> [[Element]] {
        let dbscan = DBSCAN(self)
        let (clusters, _) = dbscan(epsilon: distance, minimumNumberOfPoints: 1) { $0.distance(to: $1) }
        return clusters
    }
    
}


