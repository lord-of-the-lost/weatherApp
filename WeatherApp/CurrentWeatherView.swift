//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 07.03.2023.
//

import UIKit

final class CurrentWeatherView: UIView {
    
    enum Unit {
        case fahrenheit
        case celsius
    }
    
    enum State {
        case cold
        case normal
        case hot
    }
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Cityname"
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "31°"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fahrenheitLabel: UILabel = {
        let label = UILabel()
        label.text = "F"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let celsiusLabel: UILabel = {
        let label = UILabel()
        label.text = "C"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .clear
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "lightBlue")
        addSubview(cityLabel)
        addSubview(temperatureLabel)
        addSubview(fahrenheitLabel)
        addSubview(switcher)
        addSubview(celsiusLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            celsiusLabel.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            celsiusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switcher.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            switcher.trailingAnchor.constraint(equalTo: celsiusLabel.leadingAnchor, constant: -5),
            fahrenheitLabel.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            fahrenheitLabel.trailingAnchor.constraint(equalTo: switcher.leadingAnchor, constant: -5)
        ])
    }
}

