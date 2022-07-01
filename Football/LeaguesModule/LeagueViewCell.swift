//
//  LeaguesViewCell.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import UIKit
import Combine

class LeagueViewCell: UICollectionViewCell {
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "paintpalette")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    override init(frame: CGRect) {
        super.init (frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            logo.image = nil
            logo.alpha = 0.0
            animator?.stopAnimation(true)
            cancellable?.cancel()
        }

    func configure(with league: LeagueData) {
            nameLabel.text = league.name
            cancellable = loadImage(for: league).sink { [unowned self] image in self.showImage(image: image) }
        }

    func showImage(image: UIImage?) {
            logo.alpha = 0.0
            animator?.stopAnimation(false)
            logo.image = image
            animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.logo.alpha = 1.0
            })
        }

        private func loadImage(for league: LeagueData) -> AnyPublisher<UIImage?, Never> {
            return Just(league.logos.light)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: league.logos.light)!
                return ImageLoader.shared.loadImage(from: url)
            })
            .eraseToAnyPublisher()
        }
    
    private func setupConstraints() {
        addSubview(logo)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            logo.heightAnchor.constraint(equalToConstant: 100),
            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.topAnchor.constraint(equalTo: topAnchor),
            logo.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
