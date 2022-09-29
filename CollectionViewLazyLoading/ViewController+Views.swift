//
//  ViewController+Views.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 28/09/2022.
//

import UIKit

extension ViewController {
    func createRootView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [loadingLabel, tableView, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }

    func createLoadingLabel() -> UILabel {
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        label.isHidden = true
        return label
    }

    func createTableView() -> UITableView{
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        return table
    }

    func createDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, viewModel -> UITableViewCell? in
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = viewModel.name
            content.secondaryText = viewModel.countLabel
            cell.contentConfiguration = content
            cell.selectionStyle = .none
            return cell
        }
    }

    func createButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Load", for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loadTapped), for: .touchUpInside)
        return button
    }

    func setupSubviews() {
        view.backgroundColor = .systemBackground
        view.addSubview(rootView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            rootView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            rootView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
