//
//  ViewController.swift
//  SimpleWeather
//
//  Created by User on 14.11.2024.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    private let locationLabel = UILabel(text: "", color: .black, font: UIFont.boldSystemFont(ofSize: 52))
    private let dateLabel = UILabel(text: "", color: .gray, font: UIFont.boldSystemFont(ofSize: 35))
    private let tempLabel = UILabel(text: "", color: .black, font: UIFont.boldSystemFont(ofSize: 75))
    private let tempMinLabel = UILabel(text: "", color: .gray, font: UIFont.boldSystemFont(ofSize: 35))
    private let tempMaxLabel = UILabel(text: "", color: .gray, font: UIFont.boldSystemFont(ofSize: 35))
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.min")
        imageView.tintColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var min: String = ""
    private var max: String = ""
    private var temp: String = ""
    private var city: String = ""
    private var date: String = ""
    
    private let locationManager = CLLocationManager() //менеджер по определению геолокации
    private var currentLocation: CLLocation? //текущее местоположение
    private var latitude: CLLocationDegrees? //ширина
    private var longtitude: CLLocationDegrees? //долгота
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLocationUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        title = "Главный экран"
        
        view.backgroundColor = .yellow
        
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)
        view.addSubview(symbolImageView)
        view.addSubview(tempLabel)
        view.addSubview(tempMinLabel)
        view.addSubview(tempMaxLabel)
    }
    
    private func setupWeather() {
        tempMinLabel.text = "мин.: " + min
        tempMaxLabel.text = "мaкс.: " + max
        tempLabel.text = temp + " Cº"
        locationLabel.text = city
        dateLabel.text = date
    }
    
    private func startLocationUpdate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //выбираем точность геопозиции
        locationManager.requestWhenInUseAuthorization() //запрос авторизации
        locationManager.startUpdatingLocation() //отправляем зщапрос на обновление геоданных
    }
    
    private func fetchWeatherFromCoordinates(lat: String, long: String) {
        WeatherNetwork.shared.fetchCurrentWeather(lat: lat, long: long) { [weak self] (weather) in
           
            guard let image = weather.weather.first?.icon else { return }
            
            DispatchQueue.main.async {
                self?.min = String(weather.main.tempMin.kelvinToCelsius())
                self?.max = String(weather.main.tempMax.kelvinToCelsius())
                self?.temp = String(weather.main.temp.kelvinToCelsius())
                self?.city = weather.name
                self?.date = self?.setupDate(date: weather.dt) ?? ""
                
                self?.setupImage(image: image)
                self?.setupWeather()
            }
        }
    }
    
    private func setupImage(image: String) {
        NetworkWeatherImage.shared.requestImage(image: image) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let dataImage = UIImage(data: data)
                self.symbolImageView.image = dataImage
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupDate(date: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(date)))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            symbolImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            symbolImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            symbolImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            tempLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 20),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tempMinLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 10),
            tempMinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            tempMaxLabel.topAnchor.constraint(equalTo: tempMinLabel.bottomAnchor, constant: 2),
            tempMaxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension MainViewController: CLLocationManagerDelegate {
    //получаем данные геопозиции и присваиваем значения нашим переменным (широта/долгота)
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation() //останавлриваем обновление менеджера
        manager.delegate = nil
        
        //присваиваем значения координатам, которые получили при обновлении геопозиции
        let location = locations[0].coordinate
        latitude = location.latitude
        longtitude = location.longitude
        
        
        fetchWeatherFromCoordinates(lat: latitude!.description, long: longtitude!.description)
    }
}
