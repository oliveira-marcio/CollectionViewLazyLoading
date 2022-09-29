//
//  ViewController.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 28/09/2022.
//

import UIKit

struct RowModel: Hashable {
    let id: Int
    let count: Int
    var name: String { "Row \(id)" }
    var countLabel: String { "Update: \(count)"}
}

class ViewController: UIViewController {
    lazy var rootView: UIView = createRootView()
    lazy var loadingLabel: UILabel = createLoadingLabel()
    lazy var tableView: UITableView = createTableView()
    lazy var dataSource: DataSource = createDataSource()
    lazy var button: UIButton = createButton()

    typealias DataSource = UITableViewDiffableDataSource<Section, RowModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RowModel>

    enum Section { case main }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        display(models: createModels())
    }

    var counter = 0
    private func createModels() -> [RowModel] {
        stride(from: 1, to: 11, by: 1).map { RowModel(id: $0, count: counter) }
    }

    func display(models: [RowModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(models)
        dataSource.apply(snapShot, animatingDifferences: true)
    }

    @objc func loadTapped() {
        Task {
            counter += 1
            loadingLabel.isHidden = false
            button.isEnabled = false
            try await Task.sleep(until: .now + .seconds(2), clock: .continuous)
            loadingLabel.isHidden = true
            button.isEnabled = true
            display(models: createModels())
        }
    }
}
