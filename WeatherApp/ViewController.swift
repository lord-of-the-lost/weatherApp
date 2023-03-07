//
//  ViewController.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 05.03.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let currentWeatherView = CurrentWeatherView(frame: .zero)
    
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
        print(#function)
    }
    
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension ViewController: UITableViewDataSource {
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

