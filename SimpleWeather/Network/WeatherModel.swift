//
//  WeatherModel.swift
//  SimpleWeather
//
//  Created by Nikita Putilov on 16.11.2024.
//
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct CurrentWeatherModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let dt: Int
    let sys: Sys
    let timezone: Int
    let name: String
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax: Float

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}


// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
