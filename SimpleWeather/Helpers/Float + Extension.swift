//
//  Float + Extension.swift
//  SimpleWeather
//
//  Created by Tim Akhmetov on 19.11.2024.
//

import Foundation

extension Float {
    /*Метод для округления числа с плавающей запятой до заданного количества десятичных знаков:
     - pow(10.0, Float(val) - вычисляем 10 в степени val, на сколько десятичных знаков нужно округлить
     - * self - на это значние сдвигается точна ВПРАВО
     - floor - округляет вниз до ближайшего числа
     - второй pow(10.0, Float(val))) - возвращает десятичная точка на место, сдвигая ее влево
     
    */
    func roundFloat(_ val: Int = 1) -> Float {
        Float(floor(pow(10.0, Float(val)) * self) / pow(10.0, Float(val)))
    }
    
    func kelvinToCelsius() -> Float {
        let kelvin: Float = 273.15 //ноль по цельсию
        let kelvinValue = self
        let celsius = kelvinValue - kelvin
        
        return celsius.roundFloat()
    }
}
