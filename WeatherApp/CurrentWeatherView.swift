//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 07.03.2023.
//

import UIKit

final class CurrentWeatherView: UIView {
    
    private enum Unit {
        case fahrenheit
        case celsius
    }
    
    private enum State {
        case cold
        case normal
        case hot
    }
    
    private var unit: Unit = .fahrenheit
    
    private var currentTemperature: Double = 280
    
    private var minTemperature: Double = 260
    
    private var maxTemperature: Double = 272
    
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
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .clear
        switcher.addTarget(self, action: #selector(switcherValueChanged(_:)), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Paradise"
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "\(convertToFahrenheit(currentTemperature))°"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "min: \(convertToFahrenheit(minTemperature))°"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "max: \(convertToFahrenheit(maxTemperature))°"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func switcherValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            temperatureLabel.text = String("\(Int(convertToCelsius(currentTemperature)))°")
            minTemperatureLabel.text = String("min: \(Int(convertToCelsius(minTemperature)))°")
            maxTemperatureLabel.text = String("max: \(Int(convertToCelsius(maxTemperature)))°")
            unit = .celsius
        } else {
            temperatureLabel.text = String("\(Int(convertToFahrenheit(currentTemperature)))°")
            minTemperatureLabel.text = String("min: \(Int(convertToFahrenheit(minTemperature)))°")
            maxTemperatureLabel.text = String("max: \(Int(convertToFahrenheit(maxTemperature)))°")
            unit = .fahrenheit
        }
    }
    
    func update(city: String, temperature: Double, minTemp: Double, maxTemp: Double) {
        
        currentTemperature = temperature
        
        minTemperature = minTemp
        
        maxTemperature = maxTemp
        
        let celsius = convertToCelsius(temperature)
        
        let fahrenheit = convertToFahrenheit(temperature)
        
        cityLabel.text = city
        
        if unit == .celsius {
            temperatureLabel.text = "\(celsius)°"
            minTemperatureLabel.text = String("min: \(Int(convertToCelsius(minTemperature)))°")
            maxTemperatureLabel.text = String("max: \(Int(convertToCelsius(maxTemperature)))°")
        } else {
            temperatureLabel.text = "\(fahrenheit)°"
            minTemperatureLabel.text = String("min: \(Int(convertToFahrenheit(minTemperature)))°")
            maxTemperatureLabel.text = String("max: \(Int(convertToFahrenheit(maxTemperature)))°")
        }
        
        updateBackgroundColor(state: stateForTemperature(celsius))
    }
    
    private func convertToCelsius(_ kelvin: Double) -> Int {
        return Int(kelvin - 273.15)
    }
    
    private func convertToFahrenheit(_ kelvin: Double) -> Int {
        return Int((kelvin - 273.15) * 1.8 + 32)
    }
    
    
    private func stateForTemperature(_ celsius: Int) -> State {
        if celsius < 10 {
            return .cold
        } else if celsius < 26 {
            return .normal
        } else {
            return .hot
        }
    }
    
    private func updateBackgroundColor(state: State) {
        switch state {
        case .cold:
            backgroundColor = UIColor(named: "lightBlue")
        case .normal:
            backgroundColor = .orange
        case .hot:
            backgroundColor = .red
        }
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "lightBlue")
        addSubview(cityLabel)
        addSubview(temperatureLabel)
        addSubview(minTemperatureLabel)
        addSubview(maxTemperatureLabel)
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
            fahrenheitLabel.trailingAnchor.constraint(equalTo: switcher.leadingAnchor, constant: -5),
            minTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor),
            minTemperatureLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 10),
            maxTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor),
            maxTemperatureLabel.leadingAnchor.constraint(equalTo: minTemperatureLabel.trailingAnchor, constant: 10),
        ])
    }
}

