import Foundation
import Combine

enum ApiConstants {
    case stationInformationEndpoint
    case stationStatusEndpoint

    var endpoint: String {
        switch self {
        case .stationInformationEndpoint:
            return "/ube/gbfs/v1/en/station_information"
        case .stationStatusEndpoint:
            return "/ube/gbfs/v1/en/station_status"
        }
    }
}

extension ApiConstants {
    var url: URL {
        let host = "https://barcelona.publicbikesystem.net"
        return URL(string: "\(host)\(self.endpoint)")!
    }
}

// MARK: - StationStatusResponse
struct StationStatusResponse: Codable {
    let lastUpdated: Int
    let ttl: Int
    let data: StatusDataClass

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case ttl = "ttl"
        case data = "data"
    }
}

// MARK: - StatusDataClass
struct StatusDataClass: Codable {
    let stations: [StatusStation]

    enum CodingKeys: String, CodingKey {
        case stations = "stations"
    }
}

// MARK: - Station
struct StatusStation: Codable {
    let stationId: String
    let numBikesAvailable: Int
    let numBikesAvailableTypes: NumBikesAvailableTypes
    let numBikesDisabled: Int
    let numDocksAvailable: Int
    let numDocksDisabled: Int
    let isInstalled: Int
    let isRenting: Int
    let isReturning: Int
    let lastReported: Int
    let status: Status

    enum CodingKeys: String, CodingKey {
        case stationId = "station_id"
        case numBikesAvailable = "num_bikes_available"
        case numBikesAvailableTypes = "num_bikes_available_types"
        case numBikesDisabled = "num_bikes_disabled"
        case numDocksAvailable = "num_docks_available"
        case numDocksDisabled = "num_docks_disabled"
        case isInstalled = "is_installed"
        case isRenting = "is_renting"
        case isReturning = "is_returning"
        case lastReported = "last_reported"
        case status = "status"
    }
}

// MARK: - NumBikesAvailableTypes
struct NumBikesAvailableTypes: Codable {
    let mechanical: Int
    let ebike: Int

    enum CodingKeys: String, CodingKey {
        case mechanical = "mechanical"
        case ebike = "ebike"
    }
}

enum Status: String, Codable {
    case inService = "IN_SERVICE"
    case planned = "PLANNED"
    case notInService = "NOT_IN_SERVICE"
    case maintinance = "MAINTENANCE"
}


////

// MARK: - StationInformationResponse
struct StationInformationResponse: Codable {
    let lastUpdated: Int
    let ttl: Int
    let data: InformationDataClass

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case ttl = "ttl"
        case data = "data"
    }
}

// MARK: - DataClass
struct InformationDataClass: Codable {
    let stations: [InformationStation]

    enum CodingKeys: String, CodingKey {
        case stations = "stations"
    }
}

// MARK: - Station
struct InformationStation: Codable {
    let stationId: String
    let name: String
    let lat: Double
    let lon: Double
    let altitude: Double
    let address: String
    let postCode: String
    let capacity: Int
    let nearbyDistance: Int
    let crossStreet: String?

    enum CodingKeys: String, CodingKey {
        case stationId = "station_id"
        case name = "name"
        case lat = "lat"
        case lon = "lon"
        case altitude = "altitude"
        case address = "address"
        case postCode = "post_code"
        case capacity = "capacity"
        case nearbyDistance = "nearby_distance"
        case crossStreet = "cross_street"
    }
}

// MARK: - Station

struct Station: Codable {
    let stationId: String
    let name: String
    let lat: Double
    let lon: Double
    let altitude: Double
    let address: String
    let postCode: String
    let capacity: Int
    let nearbyDistance: Int
    let crossStreet: String?
    let numBikesAvailable: Int
    let numBikesAvailableTypes: NumBikesAvailableTypes
    let numBikesDisabled: Int
    let numDocksAvailable: Int
    let numDocksDisabled: Int
    let isInstalled: Int
    let isRenting: Int
    let isReturning: Int
    let lastReported: Int
    let status: Status
}
