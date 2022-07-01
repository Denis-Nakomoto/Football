//
//  SeasonsCell.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import UIKit

class SeasonViewCell: UICollectionViewCell {
    
    let leagueNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "League 2020"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startDatePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.text = "Started at:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endDatePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.text = "Finish at:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        label.text = "N/A"
        label.minimumScaleFactor = 0.6
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.text = "N/A"
        label.minimumScaleFactor = 0.6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init (frame: frame)
        setupConstraints()
        backgroundColor = .lightGray.withAlphaComponent(0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }

    func configure(with season: Season) {
        leagueNameLabel.text = season.displayName
        startDateLabel.text = season.startDate
        endDateLabel.text = season.endDate
        }
    
    private func setupConstraints() {
        addSubview(leagueNameLabel)
        
        NSLayoutConstraint.activate([
            leagueNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            leagueNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            leagueNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        
        addSubview(startDatePlaceholderLabel)
        
        NSLayoutConstraint.activate([
            startDatePlaceholderLabel.topAnchor.constraint(equalTo: leagueNameLabel.bottomAnchor, constant: 10),
            startDatePlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            startDatePlaceholderLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        addSubview(endDatePlaceholderLabel)
        
        NSLayoutConstraint.activate([
            endDatePlaceholderLabel.topAnchor.constraint(equalTo: startDatePlaceholderLabel.bottomAnchor, constant: 8),
            endDatePlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            endDatePlaceholderLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        addSubview(startDateLabel)
        
        NSLayoutConstraint.activate([
            startDateLabel.topAnchor.constraint(equalTo: startDatePlaceholderLabel.topAnchor),
            startDateLabel.leadingAnchor.constraint(equalTo: startDatePlaceholderLabel.trailingAnchor, constant: 8),
            startDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        addSubview(endDateLabel)
        
        NSLayoutConstraint.activate([
            endDateLabel.topAnchor.constraint(equalTo: endDatePlaceholderLabel.topAnchor),
            endDateLabel.leadingAnchor.constraint(equalTo: startDatePlaceholderLabel.trailingAnchor, constant: 8),
            endDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }
}


