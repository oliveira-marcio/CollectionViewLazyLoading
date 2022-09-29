//
//  ViewController+Views.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 28/09/2022.
//

import UIKit

extension ViewController {
    func createRootView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [tableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(8, after: tableView)
        stackView.axis = .vertical
        return stackView
    }

    internal func createTableView() -> UITableView{
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        return table
    }

    func createDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, viewModel -> UITableViewCell? in
            var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = viewModel.name
            content.secondaryText = viewModel.countLabel
            cell.contentConfiguration = content
            cell.selectionStyle = .none
            return cell
        }
    }

    func setupSubviews() {
        view.backgroundColor = .systemBackground
        view.addSubview(rootView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            rootView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            rootView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}
