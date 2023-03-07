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

var recentRequests: [RecentRequestViewModel] = [RecentRequestViewModel(cityName: "Москва", temperature: "25", date: "20.01.2023", time: "16:52:21"), RecentRequestViewModel(cityName: "Санкт-Петербург", temperature: "-12", date: "20.01.2022", time: "18:52:21"), RecentRequestViewModel(cityName: "Сызрань", temperature: "9", date: "10.08.2021", time: "02:51:21")]
