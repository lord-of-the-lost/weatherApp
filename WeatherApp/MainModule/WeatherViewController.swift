//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 05.03.2023.
//

import CoreData
import CoreLocation
import UIKit

final class WeatherViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let currentWeatherView = CurrentWeatherView(frame: .zero)
    
    private let locationManager = CLLocationManager()
    
    private var recentRequests: [NSManagedObject] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDeligate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WeatherRequestItem")
        
        do {
            recentRequests = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
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
    
    @objc private func getCurrentLocationButtonTapped() {
        locationManager.requestLocation()
    }
    
    private func save(city: String, temperature: String, date: String, time: String) {
        guard let appDeligate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDeligate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "WeatherRequestItem", in: managedContext) else { return }
        let weatherRequestItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        weatherRequestItem.setValue(city, forKey: "city")
        weatherRequestItem.setValue(temperature, forKey: "temperature")
        weatherRequestItem.setValue(date, forKey: "date")
        weatherRequestItem.setValue(time, forKey: "time")
        
        do {
            try managedContext.save()
            recentRequests.append(weatherRequestItem)
        } catch let error as NSError {
            print(error)
        }
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
                        self?.save(city: recentRequestItem.cityName, temperature: recentRequestItem.temperature, date: recentRequestItem.date, time: recentRequestItem.time)
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
        let weatherRequest = recentRequests[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentRequestCell", for: indexPath) as? RecentRequestCell,
              let city = weatherRequest.value(forKey: "city") as? String,
              let temperatureString = weatherRequest.value(forKey: "temperature") as? String,
              let temperature = Int(temperatureString),
              let date = weatherRequest.value(forKey: "date") as? String,
              let time = weatherRequest.value(forKey: "time") as? String
        else {
            return UITableViewCell()
        }
        
        cell.topLabel.text = "\(city), \(temperature)°F"
        cell.bottomLabel.text = "\(date) \(time)"
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
