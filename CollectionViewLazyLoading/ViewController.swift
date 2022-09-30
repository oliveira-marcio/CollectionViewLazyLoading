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

    var interactor1 = Interactor(id: 1, delay: 3)
    var interactor2 = Interactor(id: 2, delay: 2)
    var interactor3 = Interactor(id: 3, delay: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        display(models: createModels())
    }

    private func createModels() -> [RowModel] {
        stride(from: 1, to: 11, by: 1).map { RowModel(id: $0, count: 0) }
    }

    func display(models: [RowModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(models)
        dataSource.apply(snapShot, animatingDifferences: true)
    }

    @objc func loadTapped() {
        Task {
            loadingLabel.isHidden = false
            button.isEnabled = false
            await withTaskGroup(of: Void.self) { group in
                group.addTask { [weak self] in await self?.getData(with: self?.interactor1) }
                group.addTask { [weak self] in await self?.getData(with: self?.interactor2) }
                group.addTask { [weak self] in await self?.getData(with: self?.interactor3) }
            }
            loadingLabel.isHidden = true
            button.isEnabled = true
        }
    }

    func getData(with interactor: Interactor?) async {
        await interactor?.fetchData()
        print("Interactor \(interactor?.model?.id ?? -1) finished")
    }
}
