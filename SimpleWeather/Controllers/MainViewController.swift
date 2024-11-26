//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Nikita Putilov on 14.11.2024.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeLabel = UILabel(text: "", color: .darkGray, font: UIFont.boldSystemFont(ofSize: 40))
    private let locationLabel = UILabel(text: "", color: .black, font: UIFont.boldSystemFont(ofSize: 35))
    private let dateLabel = UILabel(text: "", color: .gray, font: UIFont.boldSystemFont(ofSize: 25))
    private let descriptionLabel = UILabel(text: "", color: .black, font: UIFont.boldSystemFont(ofSize: 48))
    private let tempLabel = UILabel(text: "", color: .black, font: UIFont.boldSystemFont(ofSize: 75))
    private let tempMaxMinLabel = UILabel(text: "", color: .gray, font: UIFont.boldSystemFont(ofSize: 15))
//    private let tempMinLabel = UILabel(text: "", color: .gray, font: UIFont.boldSystemFont(ofSize: 15))
//    private let tempMaxLabel = UILabel(text: "", color: .gray, font: UIFont.boldSystemFont(ofSize: 15))
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var descriptionWeather: String = ""
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
        
        activityIndicator.startAnimating()
        startLocationUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        title = "Главный экран"
        
        view.backgroundColor = .yellow
        
        view.addSubview(activityIndicator)
        view.addSubview(placeLabel)
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)
        view.addSubview(symbolImageView)
        view.addSubview(tempLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(tempMaxMinLabel)
//        view.addSubview(tempMinLabel)
//        view.addSubview(tempMaxLabel)
    }
    
    private func setupWeather() {
        placeLabel.text = "Текущее место"
        tempMaxMinLabel.text = "Макс.: \(max),мин.:\(min)"
//        tempMinLabel.text = "мин.: " + min
//        tempMaxLabel.text = "мaкс.: " + max
        tempLabel.text = temp + "º"
        locationLabel.text = city
        dateLabel.text = date
        descriptionLabel.text = descriptionWeather
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
    }
    
    private func startLocationUpdate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //выбираем точность геопозиции
        locationManager.requestWhenInUseAuthorization() //запрос авторизации
        locationManager.startUpdatingLocation() //отправляем зщапрос на обновление геоданных
    }
    
    private func fetchWeatherFromCoordinates(lat: String, long: String) {
        WeatherNetwork.shared.fetchCurrentWeather(lat: lat, long: long) { [weak self] (weather) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.min = String(weather.main.tempMin.kelvinToCelsius())
                self.max = String(weather.main.tempMax.kelvinToCelsius())
                self.temp = String(weather.main.temp.kelvinToCelsius())
                self.city = weather.name.uppercased() //название города - все с большой буквы
                self.date = self.setupDate(date: weather.dt) ?? ""
                
                for (_, data) in weather.weather.enumerated() {
                    self.descriptionWeather = data.description.capitalized // первая буква большая
                    self.setupImage(image: data.icon)
                }
                
                self.activityIndicator.stopAnimating()
                self.setupWeather()
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
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(date)))
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            placeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            locationLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tempLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            symbolImageView.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 20),
            symbolImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 2.5),
            symbolImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2.5),
            
            descriptionLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 2),
          //  descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
          //  descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tempMaxMinLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            tempMaxMinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
//            tempMinLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
//            tempMinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            tempMaxLabel.topAnchor.constraint(equalTo: tempMinLabel.bottomAnchor, constant: 2),
//            tempMaxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension MainViewController: CLLocationManagerDelegate {
    //получаем данные геопозиции и присваиваем значения нашим переменным (широта/долгота)
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation() //останавлриваем обновление менеджера
        manager.delegate = nil
        
        //присваиваем значения координатам, которые получили при обновлении геопозиции
        guard let location = locations.first?.coordinate else { return }
        latitude = location.latitude
        longtitude = location.longitude
        
        if let lat = latitude?.description, let long = longtitude?.description {
            fetchWeatherFromCoordinates(lat: lat, long: long)
        }
    }
}
