//
//  InfectionTypeTableViewController.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/22/21.
//

import UIKit
import APIKit

class InfectionTypesViewController: UIViewController {
    @IBOutlet weak var circularView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitReportButton: UIButton!

    private var lastSelectedIndexPath: IndexPath?
    private var infectionConditions: [InfectionCondition] = []

    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        validateSubmitFormButton()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        circularView.backgroundColor = PathManager.shared.pointOption == 1 ? .systemGreen : .systemOrange
        circularView.layer.cornerRadius = circularView.bounds.height / 2
    }

    func configureLayout() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
    }

    func fetchData() {
        let userOrganization = OrganizationManager.shared.getOrganization()
        let request = StedsCareAPI.FetchInfectionConditionsRequest(organizationId: Int(userOrganization.id))
        Session.send(request, handler: { result in
            switch result {
            case .success(let response):
                self.infectionConditions.append(contentsOf: response)
                self.collectionView.reloadData()
                break
            case .failure(let error):
                printError(error)
            }
        })
    }

    func validateSubmitFormButton() {
        submitReportButton.isEnabled = lastSelectedIndexPath != nil
        submitReportButton.backgroundColor = lastSelectedIndexPath != nil ? .link : .systemGray6
        submitReportButton.titleLabel?.textColor = lastSelectedIndexPath != nil ? .white : .systemGray4
    }
}

// Segues
extension InfectionTypesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  submitViewController = segue.destination as? SubmitReportViewController, let index = lastSelectedIndexPath?.row {
            let infection = infectionConditions[index]
            submitViewController.infectionCondition = infection
        }
    }
}

extension InfectionTypesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard lastSelectedIndexPath != indexPath else { return }
        if let index = lastSelectedIndexPath {
            let cell = collectionView.cellForItem(at: index) as! InfectionCollectionViewCell
            cell.isSelected = false
        }

        let cell = collectionView.cellForItem(at: indexPath) as! InfectionCollectionViewCell
        cell.isSelected = true
        lastSelectedIndexPath = indexPath
        validateSubmitFormButton()
    }
}

extension InfectionTypesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfectionCollectionViewCell.cellIdentifier, for: indexPath) as! InfectionCollectionViewCell

        let infection = infectionConditions[indexPath.row]
        cell.configure(infection)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infectionConditions.count
    }
}

extension InfectionTypesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right
        let availableWidth = collectionView.bounds.width - paddingSpace
        let paddingSpaceHeight = sectionInsets.bottom + sectionInsets.top
        let availableHeight = 60 - paddingSpaceHeight
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: availableHeight)
    }
}
