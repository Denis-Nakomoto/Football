//
//  StandsCell.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import UIKit

class StandsCell: UICollectionViewCell {

    let teamInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Team Info"
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statisticsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Statistics"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let teamStackView = UIStackView(arrangedSubviews: [], axis: .vertical, spacing: 7)
    
    let statisticsStackView = UIStackView(arrangedSubviews: [], axis: .vertical, spacing: 7)
    
    override init(frame: CGRect) {
        super.init (frame: frame)
        setupConstraints()
        backgroundColor = .lightGray.withAlphaComponent(0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamStackView.removeAllArrangedSubviews()
        statisticsStackView.removeAllArrangedSubviews()
    }
    
    func configure(with stand: Standing) {
        let teamName = stand.team?.name
        let teamLocation = stand.team?.location
        let teamAbreviation = stand.team?.abbreviation
        let teamaIsActive = stand.team?.isActive
        
        let nameLbl = UILabel(text: teamName ?? "-")
        let locationLbl = UILabel(text: teamLocation ?? "-")
        let abreviationLbl = UILabel(text: teamAbreviation ?? "-")
        let isActiveLbl = UILabel(text: String(describing: teamaIsActive ?? false))
        
        teamStackView.addArrangedSubview(nameLbl)
        teamStackView.addArrangedSubview(locationLbl)
        teamStackView.addArrangedSubview(abreviationLbl)
        teamStackView.addArrangedSubview(isActiveLbl)
        
        let statsName = stand.stats?.first?.displayName
        let statsDescription = stand.stats?.first?.shortDisplayName
        let statsValue = stand.stats?.first?.value
        let statsType = stand.stats?.first?.displayName
        
        let statsLbl = UILabel(text: String(describing: statsName ?? .points))
        let statsDescriptionLbl = UILabel(text: String(describing: statsDescription ?? .a))
        let statsValueLbl = UILabel(text: String(describing: statsValue ?? 0))
        let statsTypeLbl = UILabel(text: String(describing: statsType ?? .points))
        
        statisticsStackView.addArrangedSubview(statsLbl)
        statisticsStackView.addArrangedSubview(statsDescriptionLbl)
        statisticsStackView.addArrangedSubview(statsValueLbl)
        statisticsStackView.addArrangedSubview(statsTypeLbl)
    }

    private func setupConstraints() {
        
        addSubview(teamInfoLabel)

        NSLayoutConstraint.activate([
            teamInfoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            teamInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ])

        addSubview(statisticsLabel)

        NSLayoutConstraint.activate([
            statisticsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            statisticsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        
        addSubview(teamStackView)
        teamStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            teamStackView.topAnchor.constraint(equalTo: teamInfoLabel.bottomAnchor, constant: 10),
            teamStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            teamStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        addSubview(statisticsStackView)
        statisticsStackView.alignment = .trailing
        statisticsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statisticsStackView.topAnchor.constraint(equalTo: statisticsLabel.bottomAnchor, constant: 10),
            statisticsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            statisticsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
