//
//  UserHealthViewController.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/15/21.
//

import Foundation
import UIKit

class UserExposuresViewController: UICollectionViewController {
    @IBOutlet weak var circularView: UIView!
    
    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, ExposedDomain>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ExposedDomain>

    var dataSource: DataSource!

    let exposuresRepository = Application.shared.services.makeExposuresRepository()

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        circularView.backgroundColor = PathManager.shared.pointOption == 1 ? .systemGreen : .systemOrange
        circularView.layer.cornerRadius = circularView.bounds.height / 2

        fetchExposures()
    }

    func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(94))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)

        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)

        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(fetchExposures), for: .valueChanged)

        dataSource = DataSource(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExposedViewCell.identifier, for: indexPath)
            if let cell = cell as? ExposedViewCell {
                cell.bind(exposed: item)
            }

            return cell
        }
    }

    @objc func fetchExposures() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let fetchExposuresResult = self?.exposuresRepository.exposures() else { return }
            switch fetchExposuresResult {
            case .success(let exposures):
                var snapshot = Snapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(exposures, toSection: .main)

                DispatchQueue.main.async {
                    self?.dataSource.apply(snapshot)
                }
            case .failure(let error):
                print("Failed to populate list of exposures. \(error)")
            }

            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
