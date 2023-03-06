//
//  ViewController.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 05.03.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationController()
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
    
    @objc func getCurrentLocationButtonTapped() {
        print(#function)
    }
    
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
