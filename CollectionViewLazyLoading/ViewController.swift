//
//  ViewController.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 28/09/2022.
//

import UIKit

struct RowModel: Hashable {
    let id: Int
    var name: String { "Row \(id)" }
    let count = 0
    var countLabel: String { "Update: \(count)"}
}

class ViewController: UIViewController {
    lazy var rootView: UIView = createRootView()
    lazy var tableView: UITableView = createTableView()
    lazy var dataSource: DataSource = createDataSource()

    typealias DataSource = UITableViewDiffableDataSource<Section, RowModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RowModel>

    enum Section { case main }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        display(models: createModels())
    }

    private func createModels() -> [RowModel] {
        stride(from: 1, to: 11, by: 1).map { RowModel(id: $0) }
    }

    func display(models: [RowModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(models)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
