//
//  ViewController.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 28/09/2022.
//

import UIKit

/**
 * The goal here is to update separated rows of the table view based on asynchronous interactors responses with data for each row.
 *
 * Therefore, we can just create updated snapshots as soon as we receive the data from each interactor, and apply them to the table view.
 * Because of the capabilities of `UITableViewDiffableDataSource`, no unnecessary refresh will be done in rows with unchanged
 * data when we apply the snapshot with the full list of models.
 *
 * The `rowMap` will keep an indexed list of models to be updated as they are asynchronously received and the snapshots will always be
 * created from it. The indexes will also ensure that the rows will be assembled in the correct order.
 *
 * In the first run, the map will be empty, so the table view will grow accordingly to the data received. The next runs will only update the
 * contents of the rows.
 */

class ViewController: UIViewController {
    lazy var rootView: UIView = createRootView()
    lazy var loadingLabel: UILabel = createLoadingLabel()
    lazy var tableView: UITableView = createTableView()
    lazy var dataSource: DataSource = createDataSource()
    lazy var button: UIButton = createButton()

    typealias DataSource = UITableViewDiffableDataSource<Section, InteractorModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, InteractorModel>

    enum Section { case main }

    var interactors = [Interactor]()
    var rowMap = [Int: InteractorModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        createInteractors(10)
    }

    /// Helper to dynamically create multiple interactors. The number of table rows will match it.
    func createInteractors(_ quantity: Int) {
        Array(1...quantity).forEach { interactors.append(Interactor(id: $0)) }
    }

    /// Helper to shuffle the interactors delays so it will be easier to notice the rows updates.
    /// Each interactor will complete 1 second after the previous one.
    func shuffleInteractorsDelays() {
        interactors.shuffled().enumerated().forEach { delay, interactor in
            interactor.delay = delay
        }
    }

    func display(models: [InteractorModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(models)
        dataSource.apply(snapShot, animatingDifferences: true)
    }

    func display(loading: Bool) {
        loadingLabel.isHidden = !loading
        button.isEnabled = !loading
    }

    @objc func loadTapped() {
        Task {
            display(loading: true)
            shuffleInteractorsDelays()
            await withTaskGroup(of: Void.self) { group in
                interactors.forEach { interactor in
                    group.addTask { [weak self] in await self?.getData(with: interactor) }
                }
            }
            display(loading: false)
        }
    }

    func getData(with interactor: Interactor?) async {
        await interactor?.fetchData()
        refreshTableView(with: interactor?.model)
    }

    func refreshTableView(with model: InteractorModel?) {
        guard let model = model else { return }
        rowMap[model.id] = model
        display(models: getSortedModels())
    }

    func getSortedModels() -> [InteractorModel] {
        rowMap
            .sorted { $0.0 < $1.0 }
            .map { $0.1 }
    }
}
