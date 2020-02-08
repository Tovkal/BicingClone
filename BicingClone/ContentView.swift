import SwiftUI
import Combine

struct Station {
    let latitude: Double
    let longitude: Double
}

struct TestButton: View {
    @ObservedObject var viewModel: MapViewViewModel

    var body: some View {
        Button(action: {
            self.viewModel.testButtonTap.send()
        }) {
            Text("Click to add a station at a random location")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct ContentView: View {
    @ObservedObject var mapViewModel = MapViewViewModel()
    
    var body: some View {
        ZStack {
            MapView(stations: $mapViewModel.stations)
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                Spacer()
                TestButton(viewModel: mapViewModel)
            }
            .padding(.bottom, 25)
        }
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
    
    @Binding var stations: [Station]

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        let center = CLLocationCoordinate2D(latitude: 41.4024, longitude: 2.1952)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        uiView.removeAnnotations(uiView.annotations)
        for station in stations {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: station.latitude,
                                                    longitude: station.longitude)
            annotation.coordinate = coordinate
            uiView.addAnnotation(annotation)
        }
    }
}

class MapViewViewModel: ObservableObject {

    @Published var stations: [Station] = [] {
        didSet {
            print(stations)
        }
    }
    let testButtonTap = PassthroughSubject<Void, Never>()
    private var bag: Set<AnyCancellable> = []

    init() {
        stations.append(contentsOf: [
        .init(latitude: 41.4048, longitude: 2.1939),
        .init(latitude: 41.4024, longitude: 2.1929)
        ])
        
        testButtonTap
            .sink {
                self.addRandomStation()
        }
        .store(in: &bag)
    }
    
    private func addRandomStation() {
        let randomLatitude = Double.random(in: 41.402...41.404)
        let randomLongitude = Double.random(in: 2.192...2.194)
        self.stations.append(.init(latitude: randomLatitude, longitude: randomLongitude))
    }
}
