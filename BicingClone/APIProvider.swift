import Foundation
import Combine

class APIProvider {
    var cancellable: AnyCancellable?

    func fetchStations() -> AnyPublisher<[Station], Error> {
        let publisher1 = URLSession.shared.dataTaskPublisher(for: ApiConstants.stationInformationEndpoint.url)
            .map { $0.data }
            .decode(type: StationInformationResponse.self, decoder: JSONDecoder())

        let publisher2 = URLSession.shared.dataTaskPublisher(for: ApiConstants.stationStatusEndpoint.url)
            .map { $0.data }
            .decode(type: StationStatusResponse.self, decoder: JSONDecoder())

        return Publishers.Zip(publisher1, publisher2)
            .map { (information, status) -> [Station] in
                var informationDictionary = [String: InformationStation]()
                information.data.stations.forEach { informationDictionary[$0.stationId] = $0 }
                var statusDictionary = [String: StatusStation]()
                status.data.stations.forEach { statusDictionary[$0.stationId] = $0 }

                var stations = [Station]()

                informationDictionary.forEach { id, stationInformation in
                    guard let stationStatus = statusDictionary[id] else { return }

                    stations.append(.init(stationId: stationInformation.stationId,
                                          name: stationInformation.name,
                                          lat: stationInformation.lat,
                                          lon: stationInformation.lon,
                                          altitude: stationInformation.altitude,
                                          address: stationInformation.address,
                                          postCode: stationInformation.postCode,
                                          capacity: stationInformation.capacity,
                                          nearbyDistance: stationInformation.nearbyDistance,
                                          crossStreet: stationInformation.crossStreet,
                                          numBikesAvailable: stationStatus.numBikesAvailable,
                                          numBikesAvailableTypes: stationStatus.numBikesAvailableTypes,
                                          numBikesDisabled: stationStatus.numBikesDisabled,
                                          numDocksAvailable: stationStatus.numDocksAvailable,
                                          numDocksDisabled: stationStatus.numDocksDisabled,
                                          isInstalled: stationStatus.isInstalled,
                                          isRenting: stationStatus.isRenting,
                                          isReturning: stationStatus.isReturning,
                                          lastReported: stationStatus.lastReported,
                                          status: stationStatus.status))
                }

                return stations
        }
        .eraseToAnyPublisher()
    }
}
