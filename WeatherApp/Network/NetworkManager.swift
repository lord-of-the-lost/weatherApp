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
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    enum NetworkError: Error {
        case decodingError
        case cityNotFound
        case invalidURL
        case invalidData
    }
    
    private init() {}
    
    func getCurrentWeather(for city: String? = nil, latitude: Double? = nil, longitude: Double? = nil, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
            
            var urlString = ""
            
            if let city = city {
                urlString = "\(baseURL)?q=\(city)&appid=\(APIKey)"
            } else if let lat = latitude, let lon = longitude {
                urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(APIKey)"
            } else {
                completion(.failure(NetworkError.cityNotFound))
                return
            }
            
            guard let url = URL(string: urlString) else {
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let data = data, error == nil else {
                    completion(.failure(error ?? NetworkError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let currentWeather = try decoder.decode(CurrentWeather.self, from: data)
                    
                    completion(.success(currentWeather))
                    
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
}
