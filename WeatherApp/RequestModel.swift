//
//  RequestModel.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 07.03.2023.
//

import Foundation

struct CurrentWeather: Decodable {
    let main: Main?
    let name: String?
}

struct Main: Decodable {
    let temp: Double?
    let tempMin: Double?
    let tempMax: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
