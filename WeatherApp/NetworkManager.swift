//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 07.03.2023.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let APIKey = "f68824d6b51c227b36a47bef8ba97b82"
    
    enum WeatherError: Error {
        case decodingError
        case cityNotFound
        case invalidURL
        case invalidData
    }
    
    private init() {}
    
    func getCurrentWeather(for city: String, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(WeatherError.cityNotFound))
            return
        }

        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(APIKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(WeatherError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error  in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(WeatherError.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let currentWeather = try decoder.decode(CurrentWeather.self, from: data)
                completion(.success(currentWeather))
            } catch {
                completion(.failure(WeatherError.decodingError))
            }
        }
        task.resume()
    }
}
