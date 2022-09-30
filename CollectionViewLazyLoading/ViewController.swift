//
//  ViewController.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 28/09/2022.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        display(models: createModels())
        createInteractors(3)
    }

    private func createModels() -> [InteractorModel] {
        stride(from: 1, to: 11, by: 1).map { InteractorModel(id: $0, count: 0) }
    }

    private func createInteractors(_ quantity: Int) {
        Array(1...quantity).forEach { interactors.append(Interactor(id: $0)) }
    }

    private func shuffleInteractorsDelays() {
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

    private func display(loading: Bool) {
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
        print("Interactor \(interactor?.model?.id ?? -1) finished")
    }
}
