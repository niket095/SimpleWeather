//
//  ViewController.swift
//  SimpleWeather
//
//  Created by User on 14.11.2024.
//

import UIKit

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
    
    private var min: String = "5"
    private var max: String = "25"
    private var temp: String = "22"
    private var city: String = "Ekaterinburg"
    private var date: String = "14 Nov 2024"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupWeather()
        setupConstraints()
    }
    
    private func setupView() {
        title = "Главный экран"
        
        view.backgroundColor = .green
        
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
            symbolImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 3),
            
            tempLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 20),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tempMinLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 10),
            tempMinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tempMaxLabel.topAnchor.constraint(equalTo: tempMinLabel.bottomAnchor, constant: 2),
            tempMaxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
