//
//  LeaguesViewController.swift
//  Football
//
//  Created by Denis Svetlakov on 30.06.2022.
//

import UIKit

enum Section: Int, CaseIterable {
    case mySection
}

class LeaguesViewController: UIViewController {
    
    var presenter: LeaguesViewPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.register(LeagueViewCell.self, forCellWithReuseIdentifier: LeagueViewCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource <Section, LeagueData>?
    
    var leagues: [LeagueData]?
    
    var filteredLeagues: [LeagueData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        createDataSource()
        setupSearchBar()
        presenter.fetchLeagues(endPoint: .getAllLeagues)
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
                                                   heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 10)
            return section
        }
        return layout
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}

//MARK: - Data source
extension LeaguesViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, LeagueData>(collectionView: collectionView,
                                                                        cellProvider: { [weak self] (collectionView,
                                                                        indexPath, league) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            guard let self = self else { return UICollectionViewCell() }
            
            switch section {
            case .mySection:
                guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: LeagueViewCell.reuseId, for: indexPath) as? LeagueViewCell
                else { fatalError() }
                
                if !(self.presenter?.isSearchMode ?? false) {
                    if let league = self.leagues?[indexPath.row] {
                        item.configure(with: league)
                    }
                } else {
                    if let filteredLeague = self.filteredLeagues {
                        let league = filteredLeague[indexPath.row]
                        item.configure(with: league)
                    }
                }
                return item
            }
        })
    }
    
}

//MARK: - Delegate
extension LeaguesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let leagues = leagues else { return }
        let league = leagues[indexPath.row]
        presenter?.coordinateToSeasonView(with: league.id, title: league.name)
    }
}

//MARK: - SearchBarDelegate
extension LeaguesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            presenter?.isSearchMode = true
            filteredLeagues = leagues?.filter({ $0.name.contains(searchText) })
            reloadData()
        } else {
            presenter?.isSearchMode = false
            filteredLeagues?.removeAll()
            reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.isSearchMode = false
        reloadData()
    }
}

extension LeaguesViewController: LeaguesViewProtocol {
    
    func reloadData() {
             var snapshot = NSDiffableDataSourceSnapshot<Section, LeagueData>()
             snapshot.appendSections([.mySection])
             let leagues = (presenter?.isSearchMode ?? false) ?  self.filteredLeagues : self.leagues
             snapshot.appendItems(leagues ?? [], toSection: .mySection)
             dataSource?.apply(snapshot, animatingDifferences: true)
     }
    
    func pushToSeasons(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
