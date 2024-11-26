//
//  WeatherImage.swift
//  SimpleWeather
//
//  Created by Nikita Putilov on 19.11.2024.
//

import Foundation

class NetworkWeatherImage {
    static let shared = NetworkWeatherImage()
    private init() {}
    
    func requestImage(image: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString = "https://openweathermap.org/img/wn/\(image)@2x.png"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}
