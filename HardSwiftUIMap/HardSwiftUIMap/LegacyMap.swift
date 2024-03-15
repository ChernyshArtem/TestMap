//
//  LegacyMap.swift
//  HardSwiftUIMap
//
//  Created by Артём Черныш on 15.03.24.
//

import ClusterMap
import Combine
import MapKit
import SwiftUI

struct LegacyMap: View {

    @Binding
    var objects: [Annotation]
    
    @StateObject
    private var dataSource = DataSource()
    
    @State
    private var activeAnnotation: Annotation?
    
    var body: some View {
        GeometryReader(content: { geometryProxy in
            Map(coordinateRegion: dataSource.region, annotationItems: dataSource.annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    switch annotation.style {
                    case .single:
                        Image(systemName: "video.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.green)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                withAnimation {
                                    activeAnnotation = annotation
                                }
                            }
                    case .cluster(let annotations):
                        ZStack {
                            Circle()
                                .foregroundStyle(.white)
                            Text("\(annotations.count.description)")
                                .frame(width: 30, height: 30)
                                .minimumScaleFactor(0.01)
                                .font(.footnote)
                                .foregroundColor(.black)
                                .background(
                                    Circle()
                                        .strokeBorder(Color.green,lineWidth: 3)
                                        .padding(-3)
                                )
                        }
                        .onTapGesture {
                            Task {
                                await dataSource.setRegion(annotation, annotations: annotations)
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .overlay {
                BottomSheet(annotation: $activeAnnotation)
            }
            .onAppear(perform: {
                dataSource.mapSize = geometryProxy.size
            })
            .onChange(of: geometryProxy.size, perform: { newValue in
                dataSource.mapSize = newValue
            })
            .onAppear {
                dataSource.bindRegion()
            }
            .task {
                await dataSource.addAnnotations(annotations: objects)
                dataSource.regionSubject.send(dataSource.findCoordinateRegion(objects))
            }
            .animation(Animation.easeIn, value: dataSource._region)
        })
    }
}

extension LegacyMap {
    
    final class DataSource: ObservableObject {
        private let clusterManager = ClusterManager<Annotation>()
        private var cancellables = Set<AnyCancellable>()
        
        @Published var annotations: [Annotation] = []
        
        var mapSize: CGSize = .zero
        var regionSubject = PassthroughSubject<MKCoordinateRegion, Never>()
        var _region = MKCoordinateRegion()

        var region: Binding<MKCoordinateRegion> {
            Binding(
                get: { self._region },
                set: { newValue in
                    self.regionSubject.send(newValue)
                }
            )
        }
        
        func bindRegion() {
            regionSubject
                .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
                .sink { newRegion in
                    self._region = newRegion
                    Task { await self.reloadAnnotations() }
                }
                .store(in: &cancellables)
        }
        
        func addAnnotations(annotations: [Annotation]) async {
            var annotationsToReleaze: [Annotation] = annotations
            let coordinateRandomizer = CoordinateRandomizer()
            let points = coordinateRandomizer.generateRandomCoordinates(count: 5000, within: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.683318, longitude: -98.212695), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 150)))
                let points2 = coordinateRandomizer.generateRandomCoordinates(count: 5000, within: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29, longitude: 81), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 150)))
                var a = annotationsToReleaze.count
                for point in points {
                    a += 1
                    annotationsToReleaze.append(Annotation(id: UUID(), coordinate: point))
                }
                for point in points2 {
                    a += 1
                    annotationsToReleaze.append(Annotation(id: UUID(), coordinate: point))
                }
            await clusterManager.add(annotationsToReleaze)
            await reloadAnnotations()
        }
        
        func removeAnnotations() async {
            await clusterManager.removeAll()
            await reloadAnnotations()
        }
        
        func setRegion(_ annotation: Annotation , annotations: [Annotation]) async {
            self._region = MKCoordinateRegion(center: annotation.coordinate, span: findCoordinateRegion(annotations).span)
            await self.reloadAnnotations()
        }
        
        private func reloadAnnotations() async {
            async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: _region)
            await applyChanges(changes)
        }
        
        func findCoordinateRegion(_ annotations: [Annotation]) -> MKCoordinateRegion {
            let minLat = annotations.max { firstAnnotation, secondAnnotation in
                firstAnnotation.coordinate.latitude > secondAnnotation.coordinate.latitude
            }?.coordinate.latitude ?? 0
            let maxLat = annotations.max { firstAnnotation, secondAnnotation in
                firstAnnotation.coordinate.latitude < secondAnnotation.coordinate.latitude
            }?.coordinate.latitude ?? 0
            let minLong = annotations.max { firstAnnotation, secondAnnotation in
                firstAnnotation.coordinate.longitude > secondAnnotation.coordinate.longitude
            }?.coordinate.longitude ?? 0
            let maxLong = annotations.max { firstAnnotation, secondAnnotation in
                firstAnnotation.coordinate.longitude < secondAnnotation.coordinate.longitude
            }?.coordinate.longitude ?? 0
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: (maxLat + minLat) / 2, longitude: (maxLong + minLong) / 2),
                span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3, longitudeDelta: (maxLong - minLong) * 1.3))
        }
        
        @MainActor
        private func applyChanges(_ difference: ClusterManager<Annotation>.Difference) {
            for removal in difference.removals {
                switch removal {
                case .annotation(let annotation):
                    annotations.removeAll { $0 == annotation }
                case .cluster(let clusterAnnotation):
                    annotations.removeAll { $0.id == clusterAnnotation.id }
                }
            }
            for insertion in difference.insertions {
                switch insertion {
                case .annotation(let newItem):
                    annotations.append(newItem)
                case .cluster(let newItem):
                    annotations.append(
                        Annotation(
                            id: newItem.id,
                            coordinate: findCoordinateRegion(newItem.memberAnnotations).center,
                            style: .cluster(annotations: newItem.memberAnnotations)
                        )
                    )
                }
            }
        }
    }
}
