//
//  ContentView.swift
//  TestMap
//
//  Created by Артём Черныш on 28.02.24.
//

import SwiftUI
import MapKit

struct Place: Identifiable, Equatable, MapClusterable {
    let id: Int
    let location: CLLocationCoordinate2D
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
}

struct ContentView: View {
    
    var places: [Place] = {
        var places = [
            Place(id: 1, location: CLLocationCoordinate2D(latitude: 51.46835549272785, longitude: -0.03750000000003133)),
            Place(id: 2, location: CLLocationCoordinate2D(latitude: 51.457013659530155, longitude: -0.14905556233727052)),
            Place(id: 3, location: CLLocationCoordinate2D(latitude: 51.44401205914533, longitude: -0.005055562337271016)),
            Place(id: 4, location: CLLocationCoordinate2D(latitude: 51.4276908863969, longitude: -0.10683333333336441)),
            Place(id: 5, location: CLLocationCoordinate2D(latitude: 51.29601501405658, longitude: -0.22550000000003068)),
            Place(id: 6, location: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868)),
            Place(id: 7, location: CLLocationCoordinate2D(latitude: 35.011286, longitude: -115.166868)),
            Place(id: 8, location: CLLocationCoordinate2D(latitude: 40.712776, longitude: -74.005974)),
            Place(id: 9, location: CLLocationCoordinate2D(latitude: 34.052235, longitude: -118.243683)),
            Place(id: 10, location: CLLocationCoordinate2D(latitude: 41.878114, longitude: -87.629798)),
            Place(id: 11, location: CLLocationCoordinate2D(latitude: 29.760427, longitude: -95.369804)),
            Place(id: 12, location: CLLocationCoordinate2D(latitude: 33.748995, longitude: -84.387982)),
            Place(id: 13, location: CLLocationCoordinate2D(latitude: 37.774929, longitude: -122.419416)),
            Place(id: 14, location: CLLocationCoordinate2D(latitude: 47.606209, longitude: -122.332071)),
            Place(id: 15, location: CLLocationCoordinate2D(latitude: 39.952583, longitude: -75.165222)),
            Place(id: 16, location: CLLocationCoordinate2D(latitude: 36.167253, longitude: -115.148516)),
            Place(id: 17, location: CLLocationCoordinate2D(latitude: 32.715738, longitude: -117.161084)),
            Place(id: 18, location: CLLocationCoordinate2D(latitude: 35.501286, longitude: -115.166868))
        ]
        let coordinateRandomizer = CoordinateRandomizer()
        let points = coordinateRandomizer.generateRandomCoordinates(count: 5000, within: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.683318, longitude: -98.212695), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 150)))
            let points2 = coordinateRandomizer.generateRandomCoordinates(count: 5000, within: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29, longitude: 81), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 150)))
            var a = places.count
            for point in points {
                a += 1
                print(point)
                places.append(Place(id: a, location: point))
            }
            for point in points2 {
                a += 1
                places.append(Place(id: a, location: point))
            }
        return places
    }()
    
    var body: some View {
        MapingView(places: places)
    }
    
}

struct ClusterView: View {
    
    let cluster: MapCluster<Place>
    
    let action: () -> Void
    
    var body: some View {
        if cluster.values.count > 1 {
            ZStack {
                Circle()
                    .foregroundStyle(.white)
                Text("\(cluster.values.count)")
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
            .onTapGesture(perform: action)
        } else {
            Image(systemName: "video.circle")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.green)
                .frame(width: 30, height: 30)
                .onTapGesture {
                    openSheet()
                }
        }
    }
    
    private func openSheet() {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController
        else { return }
        
        let datePicker = UIHostingController(rootView: itemSheet)
        datePicker.title = "Details"
        datePicker.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", primaryAction: .init(handler: { _ in
            print("Select")
        }))
        datePicker.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", primaryAction: .init(handler: { _ in
            print("Cancel")
            viewController.dismiss(animated: true)
        }))
        let controller = UINavigationController(rootViewController: datePicker)
        if let sheetController = controller.sheetPresentationController {
            sheetController.detents = [.medium()]
        }
        //Надо найти tapGesture подтягивания вверх и при подтягивании вверх sheet меняем все на fullScreenCover, при нажатии Cancel всегда все закрываем
        //controller.modalPresentationStyle = .fullScreen
        viewController.present(controller, animated: true)
    }
    
    @ViewBuilder
    private var itemSheet: some View {
        Text(cluster.values.first?.id.description ?? "Empty")
    }
}
