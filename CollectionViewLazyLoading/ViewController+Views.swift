//
//  ViewController+Views.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 28/09/2022.
//

import UIKit

extension ViewController {
    func createRootView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(8, after: label)
        stackView.axis = .vertical
        return stackView
    }

    func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        return label
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
