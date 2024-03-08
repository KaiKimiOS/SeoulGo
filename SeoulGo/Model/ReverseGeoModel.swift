// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reverseGeoModel = try? JSONDecoder().decode(ReverseGeoModel.self, from: jsonData)

import Foundation

// MARK: - ReverseGeoModel
struct ReverseGeoModel: Codable {
    let status: Status
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let code: Code
    let region: Region
}

// MARK: - Code
struct Code: Codable {
    let id, type, mappingID: String

    enum CodingKeys: String, CodingKey {
        case id, type
        case mappingID = "mappingId"
    }
}

// MARK: - Region
struct Region: Codable {
    let area0, area1, area2, area3: Area
    let area4: Area
}

// MARK: - Area
struct Area: Codable {
    let name: String
    let coords: Coords
}

// MARK: - Coords
struct Coords: Codable {
    let center: Center
}

// MARK: - Center
struct Center: Codable {
    let crs: String
    let x, y: Double
}

// MARK: - Status
struct Status: Codable {
    let code: Int
    let name, message: String
}

