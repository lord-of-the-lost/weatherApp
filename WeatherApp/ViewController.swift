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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationController()
        setupView()
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
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currentWeatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
