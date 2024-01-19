//
//  UserReportsViewController.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/20/22.
//

import Foundation
import UIKit
import CoreData

class UserReportsViewController: UICollectionViewController {
    @IBOutlet weak var circularView: UIView!

    enum Section {
        case main
    }

    private let refreshControl = UIRefreshControl()

    typealias DataSource = UICollectionViewDiffableDataSource<Section, ReportDomain>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ReportDomain>

    var dataSource: DataSource!
    let reportsRepository = Application.shared.services.makeReportsRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        circularView.backgroundColor = PathManager.shared.pointOption == 1 ? .systemGreen : .systemOrange
        circularView.layer.cornerRadius = circularView.bounds.height / 2

        fetchLatestData()
    }

    func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(94))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: 16,
                                                        bottom: 12,
                                                        trailing: 16)

        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        section.interGroupSpacing = spacing

        let layout = UICollectionViewCompositionalLayout(section: section)

        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(fetchLatestData), for: .valueChanged)
    }

    func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportViewCell.identifier, for: indexPath)
            if let cell = cell as? ReportViewCell {
                cell.bind(report: item)
            }

            return cell
        }
    }

    @objc func fetchLatestData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let fetchResults = self?.reportsRepository.reports() else { return }

            switch fetchResults {
            case .success(let results):
                var snapshot = Snapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(results, toSection: .main)
                DispatchQueue.main.async {
                    self?.dataSource.apply(snapshot)
                }
            case .failure(let error):
                print("There was an error fetching repors: \(error)")
            }

            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
