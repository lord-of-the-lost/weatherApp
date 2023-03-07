//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 05.03.2023.
//

import CoreLocation
import UIKit

final class WeatherViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let currentWeatherView = CurrentWeatherView(frame: .zero)
    
    private let locationManager = CLLocationManager()
    
    private let recentRequestList: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(RecentRequestCell.self, forCellReuseIdentifier: "RecentRequestCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationController()
        setupView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        recentRequestList.dataSource = self
    }
    
    private func setNavigationController() {
        title = "Weather"
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "City name"
        searchController.searchBar.delegate = self
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .send
        
        let getCurrentLocationButton = UIBarButtonItem(title: nil,
                                                       image: UIImage(systemName: "location.north.circle"),
                                                       target: self,
                                                       action: #selector(getCurrentLocationButtonTapped))
        navigationItem.rightBarButtonItem = getCurrentLocationButton
    }
    
    private func setupView() {
        view.addSubview(currentWeatherView)
        view.addSubview(recentRequestList)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currentWeatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentRequestList.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor),
            recentRequestList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentRequestList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentRequestList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func getCurrentLocationButtonTapped() {
        locationManager.requestLocation()
    }
    
}

private extension WeatherViewController {
     func getCurrentWeather(for coordinate: CLLocationCoordinate2D? = nil, city: String? = nil) {
        NetworkManager.shared.getCurrentWeather(for: city, latitude: coordinate?.latitude, longitude: coordinate?.longitude) { [weak self] result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async { [weak self] in
                    if let cityName = weather.name, let temperature = weather.main,
                       let temp = temperature.temp, let minTemp = temperature.tempMin, let maxTemp = temperature.tempMax {
                        self?.currentWeatherView.update(city: cityName, temperature: temp, minTemp: minTemp, maxTemp: maxTemp)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.yyyy"
                        let dateString = dateFormatter.string(from: Date())
                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm:ss"
                        let timeString = timeFormatter.string(from: Date())
                        
                        let recentRequestItem = RecentRequestViewModel(cityName: cityName,
                                                                       temperature: String(convertToFahrenheit(temp)),
                                                                       date: dateString,
                                                                       time: timeString)
                        recentRequests.append(recentRequestItem)
                        self?.recentRequestList.reloadData()
                    } else {
                        print("Error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension WeatherViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
               guard let searchText = searchBar.text, !searchText.isEmpty else { return }
               getCurrentWeather(city: searchText)
           }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentRequestCell", for: indexPath) as! RecentRequestCell
        let data = recentRequests[indexPath.row]
        cell.topLabel.text = "\(data.cityName), \(data.temperature)°F"
        cell.bottomLabel.text = "\(data.date) \(data.time)"
        return cell
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let coordinate = location.coordinate
            getCurrentWeather(for: coordinate)
        }
}
