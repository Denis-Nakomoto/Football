//
//  SeasonsViewController.swift
//  Football
//
//  Created by Denis Svetlakov on 30.06.2022.
//

import UIKit

class SeasonsViewController: UIViewController {
    
    var seasons: [Season]?
    
    var presenter: SeasonsViewPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.register(SeasonViewCell.self, forCellWithReuseIdentifier: SeasonViewCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource <Section, Season>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        createDataSource()
        presenter.fetchSeasons(endPoint: .leaguesSeasons(presenter?.leagueId ?? ""))
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(130))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 10)
            return section
        }
        return layout
    }
}

//MARK: - Data source
extension SeasonsViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Season>(collectionView: collectionView,
                                                                         cellProvider: { [weak self] (collectionView,
                                                                                                      indexPath, season) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            guard let self = self else { return UICollectionViewCell() }
            
            switch section {
            case .mySection:
                guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonViewCell.reuseId, for: indexPath) as? SeasonViewCell
                else { fatalError() }
                if let season = self.seasons?[indexPath.row] {
                    item.configure(with: season)
                }
                return item
            }
        })
    }
    
}

//MARK: - Delegate
extension SeasonsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let seasons = seasons else { return }
        let season = seasons[indexPath.row]
        presenter?.coordinateToSeasonDetailView(title: season.displayName)
    }
}

extension SeasonsViewController: SeasonsViewProtocol {
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Season>()
        snapshot.appendSections([.mySection])
        snapshot.appendItems(seasons ?? [], toSection: .mySection)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func pushToStands(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
