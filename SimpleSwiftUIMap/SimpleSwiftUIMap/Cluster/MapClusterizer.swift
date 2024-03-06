import SwiftUI
import MapKit
import Combine

public struct MapClusterizer<Content: View, Item>: View where Item: MapClusterable {
    
    let clusterables: [Item]
    
    var content: ([MapCluster<Item>], Proxy) -> Content
    
    @Binding var coordinateRegion: MKCoordinateRegion
    
    @State private var clusters: [MapCluster<Item>] = []
    
    @State private var mapSpanLatitudeDeltaDidChange = PassthroughSubject<CLLocationDegrees, Never>()
    
    public init(coordinateRegion: Binding<MKCoordinateRegion>, clusterables: [Item], content: @escaping ([MapCluster<Item>], Proxy) -> Content) {
        self._coordinateRegion = coordinateRegion
        self.clusterables = clusterables
        self.content = content
    }
   
    public var body: some View {
        content(clusters, Proxy(coordinateRegion: $coordinateRegion))
            .onChange(of: coordinateRegion.span.latitudeDelta) { newValue in
                mapSpanLatitudeDeltaDidChange.send(newValue)
            }
            .onReceive(mapSpanLatitudeDeltaDidChange.debounce(for: 0.1, scheduler: RunLoop.main)) { newValue in
                let updatedClusters = clusterables.clusterize(region: coordinateRegion)
                if updatedClusters.count != clusters.count {
                    clusters = updatedClusters
                }
            }
            .onAppear {
                clusters = clusterables.clusterize(region: coordinateRegion)
            }
    }
    
}

extension MapClusterizer {
    
    public struct Proxy {
        
        @Binding var coordinateRegion: MKCoordinateRegion
        
        public func zoom(on cluster: MapCluster<Item>, factor: Double = 3) {
            
            var distance: Double = 0
            
            cluster.values.forEach { place in
                cluster.values.forEach { other in
                    if other == place { return }
                    distance = max(distance, place.distance(to: other))
                }
            }
            
            coordinateRegion = MKCoordinateRegion(center: cluster.center, latitudinalMeters: distance * factor, longitudinalMeters: distance * factor)
            
        }
        
    }
    
}
