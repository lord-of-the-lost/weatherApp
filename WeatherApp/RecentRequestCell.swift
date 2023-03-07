//
//  RecentRequestCell.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 07.03.2023.
//

import UIKit

final class RecentRequestCell: UITableViewCell {
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "doc.text.magnifyingglass"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        selectionStyle = .none
        addSubview(topLabel)
        addSubview(bottomLabel)
        addSubview(rightImage)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10),
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            rightImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
