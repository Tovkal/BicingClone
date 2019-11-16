import SwiftUI
import Combine

struct Station {
    let latitude: Double
    let longitude: Double
}

struct ContentView: View {

    var body: some View {
        MapView(viewModel: MapViewViewModel())
            .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import MapKit

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    @ObservedObject var viewModel: MapViewViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        let center = CLLocationCoordinate2D(latitude: 41.4024, longitude: 2.1952)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        for station in viewModel.stations {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: station.latitude,
                                                    longitude: station.longitude)
            annotation.coordinate = coordinate
            uiView.addAnnotation(annotation)
        }
    }

    class Coordinator: NSObject {
        private let mapView: MapView

        init(_ mapView: MapView) {
            self.mapView = mapView
        }
    }
}

class MapViewViewModel: ObservableObject {
    @Published var stations: [Station] = [
        .init(latitude: 41.4048, longitude: 2.1939),
        .init(latitude: 41.4024, longitude: 2.1929)
    ]
}
