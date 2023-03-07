//
//  RecentRequestViewModel.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 07.03.2023.
//

import UIKit

struct RecentRequestViewModel {
    let cityName: String
    let temperature: String
    let date: String
    let time: String
}

public func convertToFahrenheit(_ kelvin: Double) -> Int {
    return Int((kelvin - 273.15) * 1.8 + 32)
}
