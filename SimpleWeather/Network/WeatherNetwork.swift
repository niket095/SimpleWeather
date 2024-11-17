//
//  WeatherNetwork.swift
//  SimpleWeather
//
//  Created by Tim Akhmetov on 16.11.2024.
// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

import Foundation


class WeatherNetwork {
    
    static let shared = WeatherNetwork()
    private init() {}
    
    func fetchCurrentWeather(lat: String, long: String, completion: @escaping (CurrentWeatherModel) -> ()) {
        
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(API.apiKey)"
        
        guard let urlString = URL(string: url) else { fatalError() }
        let urlRequest = URLRequest(url: urlString)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard let data = data else { return }
            
            do {
                let currentWeather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                completion(currentWeather)
            } catch {
                print("Sorry", error)
            }
        }
        .resume()
    }
}
