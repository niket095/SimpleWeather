//
//  WeatherNetwork.swift
//  SimpleWeather
//
//  Created by Nikita Putilov on 16.11.2024.
// https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

import Foundation


class WeatherNetwork {
    
    static let shared = WeatherNetwork()
    private init() {}
    
    func fetchCurrentWeather(lat: String, long: String, completion: @escaping (CurrentWeatherModel) -> Void) {
       
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(API.apiKey)&lang=ru"
        
        guard let urlString = URL(string: url) else { fatalError() }
        let urlRequest = URLRequest(url: urlString)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, responce, error) in
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
    
    func fetchCityWeather(cityName: String, completion: @escaping (CurrentWeatherModel) -> Void) {
       
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(API.apiKey)&lang=ru"
        
        guard let urlString = URL(string: url) else { fatalError() }
        let urlRequest = URLRequest(url: urlString)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, responce, error) in
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
