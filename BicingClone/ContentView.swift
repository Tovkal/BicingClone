import SwiftUI
import Combine

struct TestButton: View {
    @ObservedObject var viewModel: MapViewViewModel

    var body: some View {
        Button(action: {
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
            let coordinate = CLLocationCoordinate2D(latitude: station.lat,
                                                    longitude: station.lon)
            annotation.coordinate = coordinate
            uiView.addAnnotation(annotation)
        }
    }
}

class MapViewViewModel: ObservableObject {

    @Published var stations: [Station] = []

    private var bag: Set<AnyCancellable> = []
    let apiProvider = APIProvider()

    init() {
        apiProvider.fetchStations()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("DONE!")
                    break
                }
            }) { (result) in
                self.stations.append(contentsOf: result)
        }
        .store(in: &bag)
    }
}
