//
//  StandsViewController.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import UIKit

class StandsViewController: UIViewController {
    
    var stands: StandsData?
    
    var seasons: [Season]?
    
    var presenter: StandsViewPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.register(StandsCell.self, forCellWithReuseIdentifier: StandsCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let changeLeagueButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        let image = UIImage(systemName: "arrow.triangle.2.circlepath",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium))
        button.setImage(image, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()
    
    let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.isHidden = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource <Section, Standing>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        createDataSource()
        presenter.fetchStands(endPoint: .leaguesStandings(presenter?.leagueId ?? ""))
        picker.delegate = self
        picker.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeLeagueButton.frame = CGRect(x: view.frame.size.width - 70,
                                          y: view.frame.size.height - 120,
                                          width: 50,
                                          height: 50)
    }
    
    private func setupConstraints() {
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(changeLeagueButton)
        changeLeagueButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(picker)
        picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func addTapped() {
        picker.isHidden = false
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(140))
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
extension StandsViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Standing>(collectionView: collectionView,
                                                                           cellProvider: { [weak self] (collectionView,
                                                                                                        indexPath, season) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            guard let self = self else { return UICollectionViewCell() }
            
            switch section {
            case .mySection:
                guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: StandsCell.reuseId, for: indexPath) as? StandsCell
                else { fatalError() }
                print(self.stands?.standings)
                if let stand = self.stands?.standings?[indexPath.row] {
                    item.configure(with: stand)
                }
                return item
            }
        })
    }
}

extension StandsViewController: StandsViewProtocol {
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Standing>()
        snapshot.appendSections([.mySection])
        snapshot.appendItems(stands?.standings ?? [], toSection: .mySection)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension StandsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return seasons?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return seasons?[row].displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        picker.isHidden = true
        title = seasons?[row].displayName
        presenter?.fetchStands(endPoint: .leaguesStandings(presenter?.leagueId ?? ""))
    }
}

